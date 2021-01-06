require 'rails_helper'

RSpec.describe 'UsersEdits', type: :system do
  subject { page }
  let(:user) { create(:user) }

  context 'unsuccessful edit' do
    before do
      login(user)
      visit edit_user_path(user)
      fill_in 'ユーザーネーム', with: ''
      fill_in 'メールアドレス', with: 'testuser@invalid'
      fill_in 'パスワード', with: 'aaa'
      fill_in 'パスワード再入力', with: 'aaa'
      # binding.pry
      click_button '更新'
    end
    it { is_expected.to have_current_path user_path(user) }
    it { is_expected.to have_selector '#error_explanation' }
    it { is_expected.to have_selector '.alert-danger' }
    it { expect(all(:css, '#error_explanation li').size).to eq 3 }
  end

  context 'successful edit' do
    describe 'friendly forwarding when access edit page without login' do
      before do
        visit edit_user_path(user)
        login(user)
      end
      it { is_expected.to have_current_path edit_user_path(user) }
      it 'session[:forwarding_url] is nil' do
        expect(page.get_rack_session[:forwarding_url]).to be_nil
      end

      describe 'account info edit' do
        let(:name) { 'foobar' }
        let(:email) { 'foo@bar.com' }
        before do
          fill_in 'ユーザーネーム', with: name
          fill_in 'メールアドレス', with: email
          fill_in 'パスワード', with: ''
          fill_in 'パスワード再入力', with: ''
          click_button '更新'
        end
        it { is_expected.to have_current_path user_path(user) }
        it { is_expected.to have_selector '.alert-success' }
        it do
          user.reload
          expect(user.name).to eq name
          expect(user.email).to eq email
        end
      end
    end
  end
end
