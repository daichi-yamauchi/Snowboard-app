require 'rails_helper'

RSpec.describe Micropost, type: :model do
  describe 'Attribute' do
    let(:micropost) { create(:micropost) }

    it { expect(micropost).to be_valid }

    describe 'user_id' do
      context 'is not be present' do
        before { micropost.user_id = nil }
        it { expect(micropost).not_to be_valid }
      end
    end

    describe 'content' do
      context 'is not be present' do
        before { micropost.content = ' ' }
        it { expect(micropost).not_to be_valid }
      end

      context 'have 141 characters' do
        before { micropost.content = 'a' * 141 }
        it { expect(micropost).not_to be_valid }
      end
    end
  end

  describe 'Order' do
    it 'is expected to be most recent first' do
      create(:micropost, :yesterday)
      now = create(:micropost)
      create(:micropost, :day_before_yesterday)
      expect(Micropost.first).to eq now
    end
  end
end
