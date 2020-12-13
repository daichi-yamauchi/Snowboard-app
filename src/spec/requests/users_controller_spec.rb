require 'rails_helper'

RSpec.describe 'UsersController', type: :request do
  describe 'GET /signup' do
    let(:base_title) { 'Snowboard App' }
    before { get signup_path }
    it { expect(response).to have_http_status :success }
  end

  describe 'GET users_path' do
    before { get users_path }
    it { expect(response).to redirect_to login_url }
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

  describe 'GET edit_user_path / PATCH user_path' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:update_info) do
      { user: { name: 'Example User',
               email: 'user@example.com' } }
    end
    describe 'should redirect edit when not logged in' do
      before { get edit_user_path(user1) }
      it { expect(flash).not_to be_empty }
      it { expect(response).to redirect_to login_url }
    end

    describe 'should not allow the admin attribute to be edited via the web' do
      let(:admin_params) do
        { user: { password: 'password',
                 password_confirmation: 'password',
                 admin: true } }
      end
      before { post_login(user1) }

      it 'not change admin attribute' do
        expect(user1.admin).to be false
        patch user_path(user1), params: admin_params
        expect(user1.reload.admin).to be false
      end
    end

    describe 'should redirect update when not logged in' do
      before { patch user_path(user1), params: update_info }
      it { expect(flash).not_to be_empty }
      it { expect(response).to redirect_to login_url }
    end

    describe 'should redirect edit when logged in as wrong user' do
      before do
        post_login(user1)
        get edit_user_path(user2)
      end
      it { expect(flash).to be_empty }
      it { expect(response).to redirect_to root_url }
    end

    describe 'should redirect update when logged in as wrong user' do
      before do
        post_login(user1)
        patch user_path(user2), params: update_info
      end
      it { expect(flash).to be_empty }
      it { expect(response).to redirect_to root_url }
    end
  end

  describe '#destroy' do
    before do
      @user = create(:user)
      @user_admin = create(:user, :admin)
    end

    context 'when not logged in' do
      it { expect { delete user_path(@user) }.to change(User, :count).by(0) }
    end

    context 'when logged in as a admin' do
      before { post_login(@user_admin) }
      it { expect { delete user_path(@user) }.to change(User, :count).by(-1) }
    end

    context 'when logged in as a non-admin' do
      before { post_login(@user) }
      it { expect { delete user_path(@user_admin) }.to change(User, :count).by(0) }
      it do
        delete user_path(@user_admin)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
