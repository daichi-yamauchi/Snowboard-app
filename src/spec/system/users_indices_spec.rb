require 'rails_helper'

RSpec.describe 'UsersIndices', type: :system do
  subject { page }
  let(:user) { create(:user) }
  let(:user_admin) { create(:user, :admin) }
  before { create_list(:user, 30) }

  context 'when logged in as non-admin' do
    before do
      login(user)
      visit '/users'
    end

    it { is_expected.to have_no_link('削除') }

    describe 'pagination' do
      it { expect(all('nav>.pagination').length).to eq 2 }

      it 'Users link is right in 1st page' do
        User.paginate(page: 1).each do |u|
          expect(find_link(u.name)[:href]).to match(/#{user_path(u)}\z/)
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
      User.paginate(page: 1).each do |u|
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
