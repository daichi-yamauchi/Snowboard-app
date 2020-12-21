require 'rails_helper'

RSpec.describe 'Sessions request', type: :request do
  describe 'GET Login Path' do
    before { get login_path }
    it { expect(response).to have_http_status(:success) }
  end

  describe 'POST #create' do
    let(:user) { create(:user) }

    context 'with remembering' do
      before { post_login(user) }
      it { expect(response).to redirect_to user_path(user) }
      it { expect(logged_in?).to be_truthy }
      it { expect(cookies[:remember_token]).to eq assigns(:user).remember_token }

      describe 'DELETE #destroy' do
        before { delete logout_path }
        it { expect(response).to redirect_to root_path }
        it { expect(logged_in?).to be_falsey }
        describe 'Re-request logout' do
          it { expect(delete(logout_path)).to be_truthy }
        end
      end
    end

    context 'without remembering' do
      before { post_login(user, remember_me: '0') }
      it 'remember_token is nil' do expect(cookies[:remember_token]).to be_nil end
    end
  end
end
