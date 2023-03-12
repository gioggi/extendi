require 'rails_helper'

RSpec.describe User, type: :model do
  # test user model
  describe 'User model' do
    it 'should have a valid factory' do
      expect(FactoryBot.build(:user)).to be_valid
    end
  end
  # test user model validations
  describe 'User model validations' do
    it 'should validate the presence of email' do
      user = FactoryBot.build(:user, email: nil)
      expect(user).to_not be_valid
      expect(user.errors.messages[:email]).to include("can't be blank")
    end
    it 'should validate the presence of password' do
      user = FactoryBot.build(:user, password: nil)
      expect(user).to_not be_valid
      expect(user.errors.messages[:password]).to include("can't be blank")
    end
  end
end
