require 'rails_helper'

RSpec.describe 'UsersController', type: :request do
  describe "#new GET signup '/signup'" do
    let(:base_title) { 'Snowboard App' }
    before { get signup_path }
    it { expect(response).to have_http_status :success }
  end

  describe "#index GET users '/users'" do
    before { get users_path }
    it { expect(response).to redirect_to login_url }
  end

  describe "#show GET user '/users/:id'" do
    context 'inactive user'
    let(:user_inactive) { create(:user, :inactive) }
    before { login(user_inactive) }
    it do
      get user_path(user_inactive)
      expect(response).to redirect_to root_path
    end
  end

  describe "#create POST users '/users'" do
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
      before { ActionMailer::Base.deliveries.clear }

      it 'is expected to change `User.count` by 0 and email sent' do
        expect { post users_path, params: valid_user_info }.to change(User, :count).by(1)
        expect(ActionMailer::Base.deliveries.size).to eq 1
      end

      describe 'After POST' do
        before { post users_path, params: valid_user_info }
        let(:user) { assigns(:user) }

        it 'is expected to redirect to root and not to activate account' do
          expect(response).to have_http_status :redirect
          expect(response).to redirect_to root_path
          expect(user.activated?).to be false
        end

        it 'is expected not to be able to login without activation' do
          post_login(user, password: user.password)
          expect(logged_in?).to be false
        end

        describe 'GET activate url' do
          it 'is expected not to activate with invalid token' do
            get edit_account_activation_path('invalid token', email: user.email)
            expect(logged_in?).to be false
          end
          it 'is expected not to activate with wrong email' do
            get edit_account_activation_path(user.activation_token, email: 'wrong')
            expect(logged_in?).to be false
          end
          it 'is expected to activate, redirect to user and to login' do
            get edit_account_activation_path(user.activation_token, email: user.email)
            expect(user.reload.activated?).to be true
            expect(response).to have_http_status :redirect
            expect(response).to redirect_to user
            expect(logged_in?).to be true
          end
        end
      end
    end
  end

  describe "#edit GET edit_user 'users/i:id/edit' / PATCH user_path" do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

    context 'when not logged in' do
      it 'is expexted to redirect to login' do
        get edit_user_path(user1)
        expect(flash).not_to be_empty
        expect(response).to redirect_to login_url
      end
    end

    context 'when logged in as wrong user' do
      before { post_login(user1) }
      it 'is expexted to redirect to root' do
        get edit_user_path(user2)
        expect(flash).to be_empty
        expect(response).to redirect_to root_url
      end
    end
  end

  describe "#update PATCH user 'user/:id'" do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:update_info) do
      { user: { name: 'Example User',
               email: 'user@example.com' } }
    end

    describe 'edit admin attribute' do
      let(:admin_params) do
        { user: { password: 'password',
                 password_confirmation: 'password',
                 admin: true } }
      end
      before { post_login(user1) }

      it 'is expexted not to change admin attribute' do
        expect(user1.admin).to be false
        patch user_path(user1), params: admin_params
        expect(user1.reload.admin).to be false
      end
    end

    context 'when not logged in' do
      it 'is expexted to redirect to login' do
        patch user_path(user1), params: update_info
        expect(flash).not_to be_empty
        expect(response).to redirect_to login_url
      end
    end

    context 'when logged in as wrong user' do
      before { post_login(user1) }
      it 'is expexted to redirect to root' do
        patch user_path(user2), params: update_info
        expect(flash).to be_empty
        expect(response).to redirect_to root_url
      end
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

  describe '#following' do
    before do
      @user = create(:user)
    end

    context 'when not logged in' do
      it 'get following page make redirect to login page' do
        get following_user_path(@user)
        expect(response).to redirect_to login_url
      end

      it 'get follower page make redirect to login page' do
        get followers_user_path(@user)
        expect(response).to redirect_to login_url
      end
    end
  end
end
