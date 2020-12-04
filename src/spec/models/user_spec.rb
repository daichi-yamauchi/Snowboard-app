require 'rails_helper'

RSpec.describe User, type: :model do
  it '有効ユーザ情報を受諾すること' do
    user = build(:user)
    expect(user).to be_valid
  end

  it '空のnameを拒否すること' do
    user = build(:user, name: ' ')
    expect(user).not_to be_valid
  end

  it '空のemailを拒否すること' do
    user = build(:user, email: ' ')
    expect(user).not_to be_valid
  end

  it '有効な長さのnameを受諾すること' do
    user = build(:user, name: 'a' * 30)
    expect(user).to be_valid
  end

  it '長過ぎるnameを拒否すること' do
    user = build(:user, name: 'a' * 31)
    expect(user).not_to be_valid
  end

  it '有効な長さのemailを受諾すること' do
    user = build(:user, email: "#{'a' * 243}@example.com")
    expect(user).to be_valid
  end

  it '長過ぎるemailを拒否すること' do
    user = build(:user, email: "#{'a' * 244}@example.com")
    expect(user).not_to be_valid
  end

  it '有効なemailの形式を受諾すること' do
    valid_emails = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_emails.each do |valid_email|
      user = build(:user, email: valid_email)
      expect(user).to be_valid
    end
  end

  it '無効なemailの形式を拒否すること' do
    invalid_emails = %w[user@example,com user_at_foo.org user.name@example.foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_emails.each do |invalid_email|
      user = build(:user, email: invalid_email)
      expect(user).not_to be_valid
    end
  end

  it '重複したメールアドレスを拒否すること' do
    user = build(:user)
    create(:user, email: user.email.upcase)
    expect(user).not_to be_valid
  end

  it 'emailは小文字で保存されること' do
    mixed_case_email = 'Foo@ExAMPle.CoM'
    user = create(:user, email: mixed_case_email)
    expect(user).not_to eq mixed_case_email.downcase
  end

  it '空のpasswordを拒否すること' do
    pw = ' ' * 8
    user = build(:user, password: pw, password_confirmation: pw)
    expect(user).not_to be_valid
  end

  it '短いpasswordを拒否すること' do
    pw = 'a' * 7
    user = build(:user, password: pw, password_confirmation: pw)
    expect(user).not_to be_valid
  end
end
