require 'rails_helper'

RSpec.describe User, type: :model do
  context "#create" do
    it "should create a new user" do
      user = User.create(email: "allan@allanbatista.com.br")

      expect(user).to be_persisted
    end

    it "should not possible to create two users with same email" do
      user = User.create(email: "allan@allanbatista.com.br")

      expect(user).to be_persisted

      user = User.create(email: "allan@allanbatista.com.br")

      expect(user).not_to be_persisted
    end
  end
end
