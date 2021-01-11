require 'rails_helper'

RSpec.describe LikePostRelationship, type: :model do
  describe 'Attribute' do
    let(:like_post_relationship) { create(:like_post_relationship) }

    it { expect(like_post_relationship).to be_valid }

    describe 'user_id' do
      context "when it's not be present" do
        before { like_post_relationship.user_id = nil }
        it { expect(like_post_relationship).not_to be_valid }
      end
    end

    describe 'post_id' do
      context "when it's not be present" do
        before { like_post_relationship.post_id = nil }
        it { expect(like_post_relationship).not_to be_valid }
      end
    end

    describe 'Order' do
      it 'is expected to be most recent first' do
        create(:like_post_relationship, :yesterday)
        now = create(:like_post_relationship)
        create(:like_post_relationship, :day_before_yesterday)
        expect(LikePostRelationship.first).to eq now
      end
    end
  end
end
