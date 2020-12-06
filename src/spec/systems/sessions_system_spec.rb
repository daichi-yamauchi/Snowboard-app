require 'rails_helper'

RSpec.describe 'Sessions system spec', type: :system do
  subject { page }

  let(:user) { create(:user) }

  describe 'Before login' do
    before { visit '/' }

    it { is_expected.to have_link 'ログイン' }
  end

  describe 'Login' do
    context 'with invalid information' do
      before do
        visit '/login'
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: ''
        click_button 'ログイン'
      end

      it { is_expected.to have_selector '.alert-danger' }

      it do
        visit '/'
        expect(page).not_to have_selector '.alert-danger'
      end
    end

    context 'with valid email/invalid password' do
      before do
        visit '/login'
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: ''
        click_button 'ログイン'
      end

      it { is_expected.to have_selector '.alert-danger' }
    end

    context 'with valid information' do
      before { login(user) }
      it { is_expected.to have_current_path user_path(User.last) }
      it { is_expected.not_to have_link login_path }

      describe 'dropdown user menu' do
        before { find_by_id('user-menu').click }
        it { is_expected.to have_link 'ログアウト' }
        it { is_expected.to have_link 'プロフィール' }

        describe 'Logout' do
          before { find_link('ログアウト').click }
          it { is_expected.to have_current_path root_path }
          it { is_expected.to have_link 'ログイン' }
          it { is_expected.not_to have_link 'ログアウト' }
          it { is_expected.not_to have_link 'プロフィール' }
        end
      end
    end
  end
end
