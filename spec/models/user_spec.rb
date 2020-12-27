require 'rails_helper'

RSpec.describe User, type: :model do
  subject { user }
  let(:user) { build(:user) }

  it { is_expected.to be_valid }

  describe 'Attribute' do
    describe 'User name' do
      context 'Empty user name' do
        before { user.name = ' ' }
        it { is_expected.not_to be_valid }
      end

      context 'Valid long user name' do
        before { user.name = 'a' * 30 }
        it { is_expected.to be_valid }
      end

      context 'Too long user name' do
        before { user.name = 'a' * 31 }
        it { is_expected.not_to be_valid }
      end
    end

    describe 'Email' do
      context 'Empty email address' do
        before { user.email = ' ' }
        it { is_expected.not_to be_valid }
      end

      context 'Valid long email address' do
        before { user.email = "#{'a' * 243}@example.com" }
        it { is_expected.to be_valid }
      end

      context 'Too long email address' do
        before { user.email = "#{'a' * 244}@example.com" }
        it { is_expected.not_to be_valid }
      end

      context 'Valid email address' do
        let(:valid_emails) do
          %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
        end
        it do
          valid_emails.each do |email|
            user.email = email
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
            user.email = email
            expect(user).not_to be_valid
          end
        end
      end

      context 'Same email address' do
        before { create(:user, email: user.email.upcase) }
        it { is_expected.not_to be_valid }
      end

      context 'Mixed case email' do
        let(:mixed_case_email) { 'Foo@ExAMPle.CoM' }
        before do
          user.email = mixed_case_email
          user.save
        end
        it { expect(user.email).to eq mixed_case_email.downcase }
      end
    end

    describe 'Password' do
      context 'Too short password' do
        let(:pw) { 'a' * 7 }
        before { user.password = user.password_confirmation = pw }
        it { is_expected.not_to be_valid }
      end
    end
  end

  describe 'Instance methods' do
    describe 'def authenticated?(remember_token)' do
      context 'remember_digest is nil' do
        it { user.authenticated?(:remember, '') }
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
      before do
        user.save
        create(:post, user: user)
      end
      it 'is expected to destroy when user is destroyed' do
        expect { user.destroy }.to change(Post, :count).by(-1)
      end
    end
  end
end
