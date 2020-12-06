require 'rails_helper'

RSpec.describe 'Users request', type: :request do
  describe 'GET /signup' do
    let(:base_title) { 'Snowboard App' }

    before { visit '/signup' }

    it { expect(page).to have_title "新規登録 | #{base_title}" }
  end

  describe 'POST users_path' do
    context 'Invalid user information post' do
      # 無効なユーザ情報
      let(:invalid_user_info) do
        { user: { name: '',
                 email: '',
                 password: '',
                 Password_confirmation: '' } }
      end

      it do
        expect { post users_path, params: invalid_user_info }.to change(User, :count).by(0)
      end
    end

    context 'Valid user information post' do
      let(:valid_user_info) do
        { user: { name: 'Example User',
                 email: 'user@example.com',
                 password: 'password',
                 password_confirmation: 'password' } }
      end

      it do
        expect { post users_path, params: valid_user_info }.to change(User, :count).by(1)
      end
    end
  end
end
