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
      before { login(user, email: '', password: '') }
      it { is_expected.to have_selector '.alert-danger' }
      it do
        visit '/'
        expect(page).not_to have_selector '.alert-danger'
      end
    end

    context 'with valid email/invalid password' do
      before { login(user, password: '') }
      it { is_expected.to have_selector '.alert-danger' }
    end

    context 'with valid information' do
      before { login(user) }
      it { is_expected.to have_current_path user_path(User.last) }
      it { is_expected.not_to have_link login_path }
      # it { expect(cookies[:remember_token]).not_to be_nil } # requests specで実施

      describe 'dropdown user menu' do
        before { find_by_id('user-menu').click }
        it { is_expected.to have_link 'ログアウト' }
        it { is_expected.to have_link 'プロフィール' }

        describe 'Logout' do
          before { find_link('ログアウト').click }
          it { is_expected.to have_current_path root_path }
          it { is_expected.to have_link 'ログイン' }
          it { is_expected.not_to have_selector '#user-menu' }
        end

        # describe 'Login without remembering' do # requests specで実施
        #   before { login(user, remember_me: true) }
        #   it { expect(cookies[:remember_token]).to be_nil }
        # end
      end
    end
  end
end
