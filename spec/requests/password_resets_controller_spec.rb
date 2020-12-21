require 'rails_helper'

RSpec.describe 'PasswordResetsController', type: :request do
  before do
    ActionMailer::Base.deliveries.clear
    @user = create(:user)
  end

  describe '#new GET password_resets_new' do
    before { get password_resets_new_path }
    it do
      expect(response).to have_http_status :success
      expect(response).to render_template 'password_resets/new'
      assert_select 'input[name=?]', 'password_reset[email]'
    end
  end

  describe '#create POST password_resets' do
    context 'Invalid email' do
      it do
        post password_resets_path, params: { password_reset: { email: '' } }
        expect(flash).not_to be_empty
      end
    end

    context 'Valid email' do
      it 'is expected to create new reset_digest and redirect to root' do
        post password_resets_path, params: { password_reset: { email: @user.email } }
        expect(@user.reset_digest).not_to eq @user.reload.reset_digest
        expect(ActionMailer::Base.deliveries.size).to eq 1
        expect(flash).not_to be_empty
        expect(response).to redirect_to root_path
      end
    end
  end

  describe '#edit GET edit_password_reset' do
    before do
      post password_resets_path, params: { password_reset: { email: @user.email } }
    end
    let(:user) { assigns(:user) }

    context 'Invalid email' do
      it do
        get edit_password_reset_path(user.reset_token, email: '')
        expect(response).to redirect_to root_path
      end
    end

    context 'Non-activated user' do
      before { user.toggle!(:activated) } # rubocop:disable Rails/SkipsModelValidations

      it do
        get edit_password_reset_path(user.reset_token, email: user.email)
        expect(response).to redirect_to root_path
      end
    end

    context 'Invalid token' do
      it do
        get edit_password_reset_path('wrong token', email: user.email)
        expect(response).to redirect_to root_path
      end
    end

    context 'Valid token' do
      it do
        get edit_password_reset_path(user.reset_token, email: user.email)
        expect(response).to have_http_status :success
        expect(response).to render_template 'password_resets/edit'
        assert_select 'input[name=email][type=hidden][value=?]', user.email
      end
    end
  end

  describe '#update PATCH password_reset' do
    before do
      post password_resets_path, params: { password_reset: { email: @user.email } }
    end
    let(:user) { assigns(:user) }

    context 'Not match password and password_confirmation' do
      it do
        patch password_reset_path(user.reset_token),
              params: { email: user.email,
                        user: { password: 'foobaz', password_confirmation: 'barquux' } }
        expect(response.body).to include 'error_explanation'
      end
    end

    context 'Empty password' do
      it do
        patch password_reset_path(user.reset_token),
              params: { email: user.email,
                        user: { password: '', password_confirmation: '' } }
        expect(response.body).to include 'error_explanation'
      end
    end

    context 'Expired token' do
      before { user.update_attribute(:reset_sent_at, 3.hours.ago) }
      it do
        patch password_reset_path(user.reset_token),
              params: { email: user.email,
                        user: { password: 'aaaaaaaa', password_confirmation: 'aaaaaaaa' } }
        expect(response).to have_http_status :redirect
        follow_redirect!
        expect(response.body).to include '有効期限'
      end
    end

    context 'Valid password' do
      it 'is expected to change password, to log in and to redirect to user' do
        patch password_reset_path(user.reset_token),
              params: { email: user.email,
                        user: { password: 'aaaaaaaa', password_confirmation: 'aaaaaaaa' } }
        expect(@user.password_digest).not_to eq @user.reload.password_digest
        expect(logged_in?).to be_truthy
        expect(flash).not_to be_empty
        expect(response).to redirect_to user
      end
    end
  end
end
