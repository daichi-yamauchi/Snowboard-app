require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:relationship) { Relationship.new(follower_id: user1.id, followed_id: user2.id) }

  it { expect(relationship).to be_valid }
  context 'follower_id is nil' do
    before { relationship.follower_id = nil }
    it { expect(relationship).not_to be_valid }
  end

  context 'followed_id is nil' do
    before { relationship.followed_id = nil }
    it { expect(relationship).not_to be_valid }
  end
end
