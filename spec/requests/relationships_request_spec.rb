require 'rails_helper'

RSpec.describe 'Relationships', type: :request do
  let(:user) { create(:user) }
  let(:other) { create(:user) }

  describe '#create' do
    context 'when not looged in' do
      it "post relationships doesn't change Relationship.count" do
        expect { post relationships_path }.to change(Relationship, :count).by(0)
        expect(response).to redirect_to login_url
      end
    end

    context 'when looged in' do
      let(:params) { { followed_id: other.id } }
      before { post_login(user) }
      it 'post relationships change Relationship.count' do
        expect { post relationships_path, params: params }.to change(Relationship, :count).by(1)
      end

      it 'post relationships with Ajax change Relationship.count' do
        expect { post relationships_path, xhr: true, params: params }.to change(Relationship, :count).by(1)
      end
    end
  end

  describe '#destroy' do
    before { create(:user, :has_relationship) }
    let(:relationship) { Relationship.first }
    context 'when not looged in' do
      it "delete relationship doesn't change Relationship.count" do
        expect { post relationships_path(relationship) }.to change(Relationship, :count).by(0)
        expect(response).to redirect_to login_url
      end
    end

    context 'when looged in' do
      let(:params) { { followed_id: other.id } }
      let(:relationship) { user.active_relationships.find_by(followed_id: other.id) }
      before do
        post_login(user)
        user.follow(other)
      end

      it 'delete relationships change Relationship.count' do
        expect { delete relationship_path(relationship) }.to change(Relationship, :count).by(-1)
      end

      it 'delete relationships with Ajax change Relationship.count' do
        expect { delete relationship_path(relationship), xhr: true }.to change(Relationship, :count).by(-1)
      end
    end
  end
end
