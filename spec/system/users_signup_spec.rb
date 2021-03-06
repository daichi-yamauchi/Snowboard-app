require 'rails_helper'

RSpec.describe 'UsersSignup', type: :system do
  subject { page }

  describe 'Render' do
    let(:base_title) { 'Snowboard App' }
    before { visit '/signup' }

    it { is_expected.to have_title full_title('新規登録') }
  end

  context 'Input valid data to form and click signup' do
    before do
      visit '/signup'
      fill_in 'ユーザーネーム', with: 'テストユーザー'
      fill_in 'メールアドレス', with: 'testuser@example.com'
      fill_in 'パスワード', with: 'password'
      fill_in 'パスワード再入力', with: 'password'
      click_button '登録'
    end

    it { is_expected.to have_current_path root_path }
    it { is_expected.to have_selector '.alert-info' }
  end

  context 'Input invalid data to form and click signup' do
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
    it { expect(all(:css, '#error_explanation li').size).to eq 4 }
  end
end
