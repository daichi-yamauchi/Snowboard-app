require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  describe 'GET Login Path' do
    before { get login_path }
    it { expect(response).to have_http_status(:success) }
  end
end
