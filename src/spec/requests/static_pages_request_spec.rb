require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  let(:base_title) { 'Snowboard App' }

  describe "GET /" do
    it "render new" do
      get '/'
      expect(response).to have_http_status(200)
      expect(response.body).to match(/<title>このアプリについて | #{base_title}<\/title>/i)
    end
  end
end
