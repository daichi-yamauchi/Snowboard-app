require 'rails_helper'

RSpec.describe 'Sessions request', type: :request do
  describe 'GET Login Path' do
    before { get login_path }
    it { expect(response).to have_http_status(:success) }
  end

  describe 'POST #create' do
    let(:user) { create(:user) }

    before do
      post login_path, params: { session: { email: user.email,
                                           password: user.password } }
    end
    it { expect(response).to redirect_to user_path(user) }

    it 'logged in' do
      expect(logged_in?).to be_truthy
    end
  end
end
