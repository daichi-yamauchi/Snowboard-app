require 'rails_helper'

RSpec.describe User, type: :model do
  it '有効性検証' do
    user = User.new(name: 'Example User', email: 'user@example.com')
    expect(user).to be_valid
  end

  it '名前に空白のみは不可の検証' do
    user = User.new(name: ' ', email: 'user@example.com')
    expect(user).not_to be_valid
  end
end
