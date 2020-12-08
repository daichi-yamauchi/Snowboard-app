require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  before do
    @user = build(:user)
    remember(@user)
  end

  context 'session is nil' do
    it 'current_user returns right user' do
      expect(current_user).to eq @user
    end

    it { expect(logged_in?).to be_truthy }
  end

  context 'remember digest is wrong' do
    before { @user.update_attribute(:remember_digest, User.digest(User.new_token)) }
    it { expect(current_user).to be_nil }
  end
end
