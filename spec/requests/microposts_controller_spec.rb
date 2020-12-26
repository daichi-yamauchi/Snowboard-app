require 'rails_helper'

RSpec.describe 'MicropostsController', type: :request do
  let(:user) { create(:user) }
  let!(:micropost) { create(:micropost) }

  describe '#create POST microposts' do
    context 'when not logged in' do
      it 'is expected not to change Micropost.count and to redirect' do
        params = { micropost: { content: 'Lorem ipsum' } }
        expect { post microposts_path, params: params }.to change(Micropost, :count).by(0)
        expect(response).to redirect_to login_url
      end
    end
  end

  describe '#destroy DELETE micropost' do
    context 'when not logged in' do
      it 'is expected not to change Micropost.count and to redirect' do
        expect { delete micropost_path(micropost) }.to change(Micropost, :count).by(0)
        expect(response).to redirect_to login_url
      end
    end

    context 'when logged in as wrong user' do
      before { post_login(user) }

      it 'is expected not to change Micropost.count and to redirect' do
        expect { delete micropost_path(micropost) }.to change(Micropost, :count).by(0)
        expect(response).to redirect_to root_url
      end
    end
  end
end
