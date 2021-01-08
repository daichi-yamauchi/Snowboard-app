require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'Attribute' do
    let(:comment) { create(:comment) }

    it { expect(comment).to be_valid }

    describe 'user_id' do
      context "when it's not be present" do
        before { comment.user_id = nil }
        it { expect(comment).not_to be_valid }
      end
    end

    describe 'post_id' do
      context "when it's not be present" do
        before { comment.post_id = nil }
        it { expect(comment).not_to be_valid }
      end
    end

    describe 'content' do
      context "when it's not be present" do
        before { comment.content = ' ' }
        it { expect(comment).not_to be_valid }
      end
    end

    describe 'Order' do
      it 'is expected to be most recent first' do
        create(:comment, :yesterday)
        now = create(:comment)
        create(:comment, :day_before_yesterday)
        expect(Comment.first).to eq now
      end
    end
  end
end
