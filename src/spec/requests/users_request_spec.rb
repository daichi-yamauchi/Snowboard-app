require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe '/signupにアクセスし、' do
    let(:base_title) { 'Snowboard App' }

    it 'タイトルが表示されること' do
      visit '/signup'
      expect(page).to have_title "新規登録 | #{base_title}"
    end

    describe '無効なユーザ情報を送信して' do
      let(:invalid_user_info) do
        { user: { name: '',
                 email: 'user@invalid',
                 password: 'foo',
                 Password_confirmation: 'bar' } }
      end

      it 'ユーザ登録されないこと' do
        expect { post users_path, params: invalid_user_info }.to change(User, :count).by(0)
      end

      it 'エラーメッセージが表示されること' do
        post users_path, params: invalid_user_info
        expect(response.body).to include 'error_explanation'
      end
    end
  end
end
