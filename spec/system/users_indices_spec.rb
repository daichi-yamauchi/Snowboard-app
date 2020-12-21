require 'rails_helper'

RSpec.describe 'UsersIndices', type: :system do
  subject { page }
  let(:user) { create(:user) }
  let(:user_admin) { create(:user, :admin) }
  before do
    create_list(:user, 15)
    create_list(:user, 3, :inactive)
    create_list(:user, 15)
  end

  context 'when logged in as non-admin' do
    before do
      login(user)
      visit '/users'
    end

    it { is_expected.to have_no_link('削除') }

    describe 'index page with pagination' do
      it { expect(all('nav>.pagination').length).to eq 2 }

      it 'is expected to show activated users links' do
        User.where(activated: true).paginate(page: 1).each do |u|
          expect(find_link(u.name)[:href]).to match(/#{user_path(u)}\z/)
        end
      end

      it 'is expected not to show inactivated user' do
        User.where(activated: false).each do |u|
          expect(page).to have_no_link(u.name)
        end
      end
    end
  end

  context 'when logged in as admin' do
    before do
      login(user_admin)
      visit '/users'
    end

    it 'Users delete link is appered' do
      User.where(activated: true).paginate(page: 1).each do |u|
        unless u == user_admin
          expect(first(:css, "a[href=\"#{user_path(u)}\"] + a[data-method=\"delete\"]")[:href]).to \
            match(/#{user_path(u)}\z/)
        end
      end
    end

    context 'when click delete button' do
      let!(:count) { User.count }
      before { accept_confirm { first(:css, "a[data-method=\"delete\"]").click } }
      it 'user count decrese by 1' do
        sleep(1)
        expect(User.count).to eq count - 1
      end
    end
  end
end
