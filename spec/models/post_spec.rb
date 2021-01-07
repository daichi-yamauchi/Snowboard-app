require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'Attribute' do
    let(:post) { create(:post) }

    it { expect(post).to be_valid }

    describe 'user_id' do
      context "when it's not be present" do
        before { post.user_id = nil }
        it { expect(post).not_to be_valid }
      end
    end

    describe 'title' do
      context "when it's not be present" do
        before { post.title = ' ' }
        it { expect(post).not_to be_valid }
      end
    end

    describe 'content' do
      context "when it's not be present" do
        before { post.content = ' ' }
        it { expect(post).not_to be_valid }
      end
    end

    describe 'Order' do
      it 'is expected to be most recent first' do
        create(:post, :yesterday)
        now = create(:post)
        create(:post, :day_before_yesterday)
        expect(Post.first).to eq now
      end
    end
  end
end
