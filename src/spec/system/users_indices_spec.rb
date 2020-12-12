require 'rails_helper'

RSpec.describe 'UsersIndices', type: :system do
  subject { page }
  let(:user) { create(:user) }
  before do
    create_list(:user, 30)
    login(user)
    visit '/users'
  end

  it '2 page navigation is appered' do
    expect(all('nav>.pagination').length).to eq 2
  end

  it 'Users is appered in 1st page' do
    User.paginate(page: 1).each do |u|
      expect(find_link(u.name)[:href]).to match(/#{user_path(u)}\z/)
    end
  end
end
