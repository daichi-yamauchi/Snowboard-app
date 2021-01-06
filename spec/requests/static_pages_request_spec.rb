require 'rails_helper'

RSpec.describe 'StaticPages', type: :request do
  let(:base_title) { 'Snowboard App' }

  describe 'visit /' do
    it 'render new' do
      visit '/'
      expect(page).to have_title full_title('ホーム')
    end
  end
end
