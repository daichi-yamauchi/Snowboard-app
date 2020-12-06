require 'rails_helper'

RSpec.describe 'Users request', type: :request do
  describe 'GET /signup' do
    let(:base_title) { 'Snowboard App' }
    before { get signup_path }
    it { expect(response).to have_http_status :success }
  end

  describe 'POST users_path' do
    context 'Invalid user information' do
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

    context 'Valid user information' do
      let(:valid_user_info) do
        { user: { name: 'Example User',
                 email: 'user@example.com',
                 password: 'password',
                 password_confirmation: 'password' } }
      end

      describe 'Post' do
        it do
          expect { post users_path, params: valid_user_info }.to change(User, :count).by(1)
        end
      end

      describe 'Response' do
        subject { response }
        before { post users_path, params: valid_user_info }

        it { is_expected.to redirect_to user_path(User.last) }
        it { is_expected.to have_http_status :redirect }
        it 'logged in' do
          expect(logged_in?).to be_truthy
        end
      end
    end
  end
end
