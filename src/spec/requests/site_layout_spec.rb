require 'rails_helper'

RSpec.describe 'layout links', type: :request do
  describe 'visit /' do
    it 'render new' do
      visit '/'
      expect(page).to have_link(href: '/signup')
    end
  end
end
