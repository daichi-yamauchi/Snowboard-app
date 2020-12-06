require 'rails_helper'

RSpec.describe 'Sessions system spec', type: :system do
  subject { page }

  describe 'Login' do
    context 'login with invalid information' do
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
  end
end
