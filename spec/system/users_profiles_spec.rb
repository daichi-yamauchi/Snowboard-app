require 'rails_helper'

RSpec.describe 'UsersProfiles', type: :system do
  subject { page }
  let(:user) { create(:user) }
  before do
    create_list(:micropost, 50, user: user)
    visit user_path(user)
  end

  it { is_expected.to have_title full_title(user.name) }
  it { expect(find('h1.title')).to have_text user.name }
  it { is_expected.to have_selector 'img.profile' }
  it { is_expected.to have_text user.microposts.count.to_s }
  it 'pagination count is 1' do
    expect(all(:css, 'nav>.pagination').count).to eq 1
  end
  it 'user profile have micropost contents' do
    user.microposts.paginate(page: 1).each do |mp|
      expect(page).to have_text mp.content
    end
  end
  it { expect(find('#following')).to have_text user.following.count }
  it { expect(find('#followers')).to have_text user.followers.count }
end
