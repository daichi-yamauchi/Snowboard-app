require 'rails_helper'

RSpec.describe 'Users system spec', type: :system do
  describe 'Signup' do
    context 'Input valid data to form and click signup' do
      subject { page }

      before do
        visit '/signup'
        fill_in 'ユーザーネーム', with: 'テストユーザー'
        fill_in 'メールアドレス', with: 'testuser@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード再入力', with: 'password'
        click_button '登録'
      end

      it { is_expected.to have_current_path user_path(User.last) }
      it { is_expected.to have_selector '.alert-success' }
    end

    context 'Input invalid data to form and click signup' do
      subject { page }

      before do
        visit '/signup'
        fill_in 'ユーザーネーム', with: ''
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: ''
        fill_in 'パスワード再入力', with: ''
        click_button '登録'
      end

      it { is_expected.to have_current_path users_path }
      it { is_expected.to have_selector '#error_explanation' }
      it { is_expected.to have_selector '.alert-danger' }

      it do
        expect(all(:css, '#error_explanation li').size).to eq 5
      end
    end
  end
end