require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /signup' do
    let(:base_title) { 'Snowboard App' }

    it 'タイトルが表示されること' do
      visit '/signup'
      expect(page).to have_title "新規登録 | #{base_title}"
    end
  end

  describe 'POST'
  context '無効なユーザ情報の場合、' do
    # 無効なユーザ情報
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
      expect(response.body).to include 'alert-danger'
    end

    context '有効なユーザ情報の場合、' do
      let(:valid_user_info) do
        { user: { name: 'Example User',
                 email: 'user@example.com',
                 password: 'password',
                 password_confirmation: 'password' } }
      end

      it 'ユーザ登録されること' do
        expect { post users_path, params: valid_user_info }.to change(User, :count).by(1)
      end

      it 'プロフィール画面へリダイレクトされること' do
        post users_path, params: valid_user_info
        expect(response.body).to redirect_to user_path(User.last)
      end
    end
  end
end
