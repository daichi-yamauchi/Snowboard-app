require 'rails_helper'

RSpec.describe 'User Model', type: :model do
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

  describe 'Class Methods' do
    describe 'def digest' do
      it { expect(User.digest('a')).not_to be nil }
    end

    describe 'def new_token' do
      it { expect(User.new_token).not_to be nil }
    end

    describe 'Instance methods' do
      let(:user) { build(:user) }
      describe 'def authenticated?(remember_token)' do
        context 'remember_digest is nil' do
          it { user.authenticated?('') }
        end
      end
    end
  end
end
