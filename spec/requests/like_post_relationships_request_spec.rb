require 'rails_helper'

RSpec.describe 'LikePostRelationships', type: :request do
  let(:user) { create(:user) }
  let(:post_data) { create(:post) }

  describe '#create' do
    let(:params) { { post_id: post_data.id } }
    context 'when not looged in' do
      it "post like_posts doesn't change LikePostRelationship.count" do
        expect { post like_post_relationships_path }.to change(LikePostRelationship, :count).by(0)
        expect(response).to redirect_to login_url
      end
    end

    context 'when looged in' do
      before { post_login(user) }
      it 'post like_posts change LikePostRelationship.count' do
        expect { post like_post_relationships_path, params: params }.to change(LikePostRelationship, :count).by(1)
      end

      it 'post like_posts with Ajax change Relationship.count' do
        expect { post like_post_relationships_path, xhr: true, params: params }.to change(LikePostRelationship, :count).by(1)
      end
    end
  end

  describe '#destroy' do
    let!(:like_post_relationship) { create(:like_post_relationship, user_id: user.id, post_id: post_data.id) }
    context 'when not looged in' do
      it "delete like_post_relationship doesn't change LikePostRelationship.count" do
        expect { delete like_post_relationship_path(like_post_relationship) }.to change(LikePostRelationship, :count).by(0)
        expect(response).to redirect_to login_url
      end
    end

    context 'when looged in' do
      before { post_login(user) }
      it 'delete like_post_relationship change LikePostRelationship.count' do
        expect { delete like_post_relationship_path(like_post_relationship) }.to change(LikePostRelationship, :count).by(-1)
      end

      it 'delete like_post_relationship with Ajax change Relationship.count' do
        expect { delete like_post_relationship_path(like_post_relationship), xhr: true }.to change(LikePostRelationship, :count).by(-1)
      end
    end
  end
end
