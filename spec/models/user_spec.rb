require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Attribute' do
    describe 'Valid user' do
      let(:user) { build(:user) }
      it { expect(user).to be_valid }
    end

    describe 'User name' do
      context 'Empty user name' do
        let(:user) { build(:user, name: ' ') }
        it { expect(user).not_to be_valid }
      end

      context 'Valid long user name' do
        let(:user) { build(:user, name: 'a' * 30) }
        it { expect(user).to be_valid }
      end

      context 'Too long user name' do
        let(:user) { build(:user, name: 'a' * 31) }
        it { expect(user).not_to be_valid }
      end
    end

    describe 'Email' do
      context 'Empty email address' do
        let(:user) { build(:user, email: ' ') }
        it { expect(user).not_to be_valid }
      end

      context 'Valid long email address' do
        let(:user) { build(:user, email: "#{'a' * 243}@example.com") }
        it { expect(user).to be_valid }
      end

      context 'Too long email address' do
        let(:user) { build(:user, email: "#{'a' * 244}@example.com") }
        it { expect(user).not_to be_valid }
      end

      context 'Valid email address' do
        let(:valid_emails) do
          %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
        end
        it do
          valid_emails.each do |email|
            user = build(:user, email: email)
            expect(user).to be_valid
          end
        end
      end

      context 'Invalid email address' do
        let(:invalid_emails) do
          %w[user@example,com user_at_foo.org user.name@example.foo@bar_baz.com foo@bar+baz.com foo@bar..com]
        end
        it do
          invalid_emails.each do |email|
            user = build(:user, email: email)
            expect(user).not_to be_valid
          end
        end
      end

      context 'Same email address' do
        let(:user) { build(:user) }
        before { create(:user, email: user.email.upcase) }
        it { expect(user).not_to be_valid }
      end

      context 'Mixed case email' do
        let(:mixed_case_email) { 'Foo@ExAMPle.CoM' }
        let(:user) { create(:user, email: mixed_case_email) }
        it { expect(user.email).to eq mixed_case_email.downcase }
      end
    end

    describe 'Password' do
      context 'Too short password' do
        let(:pw) { 'a' * 7 }
        let(:user) { build(:user, password: pw, password_confirmation: pw) }
        it { expect(user).not_to be_valid }
      end
    end
  end

  describe 'Instance methods' do
    let(:user) { create(:user) }
    let(:followed) { create(:user) }
    let(:unfollowed) { create(:user) }
    before { user.follow(followed) }

    describe 'def authenticated?(remember_token)' do
      context 'remember_digest is nil' do
        it { user.authenticated?(:remember, '') }
      end
    end

    describe 'def follow and unfollow' do
      it 'follow make following? true' do
        expect(user.following?(followed)).to be true
        expect(followed.followers.include?(user)).to be true
      end

      it 'unfollow make following? false' do
        user.unfollow(followed)
        expect(user.following?(followed)).to be false
      end
    end

    describe 'def feed' do
      before do
        create_list(:post, 10, user: user)
        create_list(:post, 10, user: followed)
        create_list(:post, 10, user: unfollowed)
      end
      it "is exected to include followed's posts" do
        followed.posts.each { |post| expect(user.feed).to include post }
      end
      it 'is exected to include my posts' do
        user.posts.each { |post| expect(user.feed).to include post }
      end
      it "is exected not to include unfollowed's posts" do
        unfollowed.posts.each { |post| expect(user.feed).not_to include post }
      end
    end
  end

  describe 'Class Methods' do
    describe 'def digest' do
      it { expect(User.digest('a')).not_to be nil }
    end

    describe 'def new_token' do
      it { expect(User.new_token).not_to be nil }
    end
  end

  describe 'Associate' do
    describe 'post dependent on user for destroy' do
      let(:user) { create(:user) }
      before { create(:post, user: user) }
      it 'is expected to destroy when user is destroyed' do
        expect { user.destroy }.to change(Post, :count).by(-1)
      end
    end

    describe 'comment dependent on user for destroy' do
      let(:user) { create(:user) }
      before { create(:comment, user: user) }
      it 'is expected to destroy when user is destroyed' do
        expect { user.destroy }.to change(Comment, :count).by(-1)
      end
    end
  end
end
