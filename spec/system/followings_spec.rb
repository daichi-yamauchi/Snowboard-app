require 'rails_helper'

RSpec.describe 'Followings', type: :system do
  subject { page }
  let!(:user) { create(:user, :has_relationship) }
  before { login(user) }

  describe 'following page' do
    before { visit following_user_path(user) }
    it { expect(user.following).not_to be_empty }
    it { expect(find('#following')).to have_text user.following.count }
    it 'followed user url is right' do
      user.following.each do |u|
        expect(find_link(u.name)['href']).to include user_path(u)
      end
    end
  end

  describe 'followers page' do
    before { visit followers_user_path(user) }
    it { expect(user.followers).not_to be_empty }
    it { expect(find('#followers')).to have_text user.followers.count }
    it 'follower user url is right' do
      user.followers.each do |u|
        expect(find_link(u.name)['href']).to include user_path(u)
      end
    end
  end

  describe 'follow' do
    let!(:other) { create(:user) }
    before { visit user_path(other) }

    it 'Follow button click increase user.following.count by 1' do
      before_count = user.following.count
      find_button('Follow').click
      expect(page).to have_button 'Unfollow'
      expect(user.following.count).to eq before_count + 1
    end

    it 'Unfollow button click decrease user.following.count by 1' do
      find_button('Follow').click
      expect(page).to have_button 'Unfollow'
      before_count = user.following.count
      find_button('Unfollow').click
      expect(page).to have_button 'Follow'
      expect(user.following.count).to eq before_count - 1
    end
  end

  describe 'feed on Home page' do
    before do
      create_list(:post, 10, user: user)
      create_list(:post, 10, user: user.following.first)
      create_list(:post, 10)
      visit root_path
    end
    it do
      user.feed.paginate(page: 1).each do |micropost|
        expect(find_by_id("post-#{micropost.id}").text).to include CGI.escapeHTML(micropost.content)
      end
    end
  end
end
