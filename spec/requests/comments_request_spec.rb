require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  let!(:user) { create(:user) }

  describe '#create' do
    let(:post_data) { create(:post) }
    context 'when logged in' do
      before { post_login(user) }
      it 'is expected to change Comment.count' do
        params = { comment: { content: 'コメントです', post_id: post_data.id } }
        expect { post comments_path, params: params }.to change(Comment, :count).by(1)
      end
    end

    context 'when not logged in' do
      it 'is expected not to change Comment.count and to redirect' do
        params = { comment: { content: 'コメントです', post_id: post_data.id } }
        expect { post comments_path, params: params }.to change(Comment, :count).by(0)
        expect(response).to redirect_to login_url
      end
    end
  end

  describe '#destroy' do
    let!(:comment) { create(:comment) }
    context 'when logged in as correct user' do
      before { post_login(comment.user) }
      it 'is expected to change Post.count by -1 and to redirect' do
        expect { delete comment_path(comment) }.to change(Comment, :count).by(-1)
        expect(response).to redirect_to root_url
      end
    end

    context 'when not logged in' do
      it 'is expected not to change Post.count and to redirect' do
        expect { delete comment_path(comment) }.to change(Comment, :count).by(0)
        expect(response).to redirect_to login_url
      end
    end

    context 'when logged in as wrong user' do
      before { post_login(user) }
      it 'is expected not to change Post.count and to redirect' do
        expect { delete comment_path(comment) }.to change(Comment, :count).by(0)
        expect(response).to redirect_to root_url
      end
    end
  end
end
