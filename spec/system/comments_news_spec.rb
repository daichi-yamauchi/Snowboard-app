require 'rails_helper'

RSpec.describe 'CommentsNews', type: :system do
  subject { page }
  let(:post) { create(:post) }

  before do
    login(post.user)
    visit post_path(post)
  end

  describe 'post comment' do
    context 'empty comment' do
      before do
        fill_in 'コメント', with: ''
        click_button 'コメントを投稿'
      end

      it { is_expected.to have_selector '#error_explanation' }
    end

    context 'valid comment' do
      let(:content) { 'テストコメントです。' }
      let(:comment) do
        fill_in 'コメント', with: content
        find('#comment_image').set('spec/fixtures/kitten.jpg')
        click_button 'コメントを投稿'
      end

      it { expect { comment }.to change(Comment, :count).by(1) }

      describe 'after post comment' do
        before { comment }
        it { is_expected.to have_current_path post_path(post) }
        it { is_expected.to have_text content }
        it { is_expected.to have_selector "#comment-#{Comment.last.id} img" }
      end
    end
  end
end
