require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:base_title) { 'Snowboard App' }

  describe 'GET /signup' do
    it 'render new' do
      visit '/signup'
      expect(page).to have_title "新規登録 | #{base_title}"
    end
  end
end
