require 'rails_helper'

RSpec.describe 'PostsNews', type: :system do
  subject { page }
  let(:user) { create(:user) }

  before do
    login(user)
    visit new_post_path
  end

  describe 'post test-post' do
    context 'empty post' do
      before do
        fill_in 'タイトル', with: ''
        fill_in '本文', with: ''
        click_button '投稿'
      end

      it { is_expected.to have_current_path posts_path }
      it { is_expected.to have_selector '#error_explanation' }
    end

    context 'valid micropost' do
      let(:title) { 'テスト' }
      let(:content) { 'テスト投稿です。' }
      let(:post) do
        fill_in 'タイトル', with: title
        fill_in '本文', with: content
        find('#post_image').set('spec/fixtures/kitten.jpg')
        click_button '投稿'
      end

      it { expect { post }.to change(Post, :count).by(1) }

      describe 'after post' do
        before { post }
        it { is_expected.to have_current_path root_path }
        it { is_expected.to have_text content }
        it { is_expected.to have_selector "#post-#{Post.last.id} img" }
      end
    end
  end
end
