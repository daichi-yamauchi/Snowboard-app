require 'rails_helper'

RSpec.describe 'PostsInterfaces', type: :system do
  subject { page }
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before do
    create_list(:post, 50, user: user)
    login(user)
    visit root_path
  end

  describe 'check display of home page' do
    it { is_expected.to have_selector 'ul.pagination' }
    it { is_expected.to have_link 'delete' }
  end

  describe 'check display of other_user page' do
    before do
      create_list(:post, 3, user: other_user)
      visit user_path(other_user)
    end
    it { is_expected.to have_no_link 'delete' }
  end

  describe 'delete post' do
    it 'Post.count decrease of 1' do
      before_count = Post.count
      accept_alert { first(:css, 'a[data-method="delete"]').click }
      expect(page).to have_selector 'div.alert-success'
      expect(Post.count).to eq before_count - 1
    end
  end
end
