require 'rails_helper'

RSpec.describe 'PostsShows', type: :system do
  subject { page }
  let(:post) { create(:post, :has_comment) }
  before do
    visit post_path(post)
  end

  it { is_expected.to have_title full_title(post.title) }
  it { expect(find('h1')).to have_text post.title }
  it { is_expected.to have_text "#{post.user.name}が投稿" }
  it { is_expected.to have_text post.comments.count.to_s }
end
