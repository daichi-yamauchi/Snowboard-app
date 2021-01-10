require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  let(:user) { create(:user) }

  describe '#create' do
    let(:post_type) { create(:post_type) }
    let(:params) { { post: { title: 'test', post_type_id: post_type.id, content: '投稿です' } } }
    context 'when logged in' do
      before { post_login(user) }
      it 'is expected to change Post.count' do
        expect { post posts_path, params: params }.to change(Post, :count).by(1)
      end
    end

    context 'when not logged in' do
      it 'is expected not to change Post.count and to redirect' do
        expect { post posts_path, params: params }.to change(Post, :count).by(0)
        expect(response).to redirect_to login_url
      end
    end
  end

  describe '#destroy' do
    let!(:post_data) { create(:post) }
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
