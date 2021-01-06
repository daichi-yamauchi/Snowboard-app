require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  let(:user) { create(:user) }
  let!(:post_data) { create(:post) }

  describe '#create POST posts' do
    context 'when not logged in' do
      it 'is expected not to change Post.count and to redirect' do
        params = { post: { title: 'test', content: 'Lorem ipsum' } }
        expect { post posts_path, params: params }.to change(Post, :count).by(0)
        expect(response).to redirect_to login_url
      end
    end
  end

  describe '#destroy DELETE post' do
    context 'when logged in as correct user' do
      before { post_login(post_data.user) }
      it 'is expected to change Post.count by -1 and to redirect' do
        expect { delete post_path(post_data) }.to change(Post, :count).by(-1)
        expect(response).to redirect_to root_url
      end
    end

    context 'when not logged in' do
      it 'is expected not to change Post.count and to redirect' do
        expect { delete post_path(post_data) }.to change(Post, :count).by(0)
        expect(response).to redirect_to login_url
      end
    end

    context 'when logged in as wrong user' do
      before { post_login(user) }
      it 'is expected not to change Post.count and to redirect' do
        expect { delete post_path(post_data) }.to change(Post, :count).by(0)
        expect(response).to redirect_to root_url
      end
    end
  end
end
