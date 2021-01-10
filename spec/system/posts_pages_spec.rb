require 'rails_helper'

RSpec.describe 'PostsShows', type: :system do
  subject { page }
  let(:post) { create(:post, :has_comment) }
  before { visit post_path(post) }

  describe 'about page title' do
    it { is_expected.to have_title full_title(post.title) }
  end

  describe 'about post' do
    it { expect(find('h1')).to have_text post.title }
    it { is_expected.to have_text "#{post.user.name}が投稿" }
  end

  describe 'about comments' do
    let(:comment_owner) { post.comments[1].user }
    before do
      login(comment_owner)
      visit post_path(post)
    end
    it { is_expected.to have_text post.comments.count.to_s }
    it 'is expected to comment.each include its content' do
      post.comments.each do |comment|
        expect(find_by_id("comment-#{comment.id}").text).to include CGI.escapeHTML(comment.content)
      end
    end
    it 'is expected to own comment have delete link' do
      post.comments.each do |comment|
        if comment.user == comment_owner
          expect(find_by_id("comment-#{comment.id}")).to have_link 'delete'
        else
          expect(find_by_id("comment-#{comment.id}")).to have_no_link 'delete'
        end
      end
    end
  end
end
