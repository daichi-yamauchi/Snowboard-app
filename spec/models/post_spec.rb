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

  describe 'Associate' do
    describe 'comment dependent on post for destroy' do
      let(:post) { create(:post) }
      before { create(:comment, post: post) }
      it 'is expected to destroy when post is destroyed' do
        expect { post.destroy }.to change(Comment, :count).by(-1)
      end
    end
  end
end
