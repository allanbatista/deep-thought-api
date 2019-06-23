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

  context "#jwt" do
    before do
      @user = User.create(email: "allan@allanbatista.com.br")
    end

    it "should create jwt with user_id" do
      jwt = @user.jwt

      user = User.find_by_jwt(jwt)

      expect(user).to eq(@user)
    end

    it "should expire jwt" do
      jwt = @user.jwt(1.second.from_now)

      sleep 1

      expect { User.find_by_jwt(jwt) }.to raise_error(JWT::ExpiredSignature)
    end

    it "should not found user with invalid jwt" do
      expect {
        User.find_by_jwt("INVALID")
      }.to raise_error(JWT::DecodeError)
    end
  end

  context ".create_or_update_by_google_oauth" do
    it "should create user with userinfo" do
      user = User.create_or_update_by_google_oauth({
        "email" => "allan@allanbatista.com.br",
        "name"  => "Allan Batista",
        "verified_email" => true,
        "picture" => "https://placehold.it/200x200"
      })

      expect(user).to be_persisted
      expect(user.email).to eq("allan@allanbatista.com.br")
      expect(user.name).to eq("Allan Batista")
      expect(user.verified_email).to eq(true)
      expect(user.picture).to eq("https://placehold.it/200x200")
    end

    it "should update user with userinfo" do
      user = User.create({
        "email" => "allan@allanbatista.com.br",
        "name"  => "Allan Batista 2",
        "verified_email" => false,
        "picture" => "https://placehold.it/200x200"
      })

      user_find = User.create_or_update_by_google_oauth({
        "email" => "allan@allanbatista.com.br",
        "name"  => "Allan Batista",
        "verified_email" => true,
        "picture" => "https://placehold.it/200x200"
      })

      expect(user.id).to eq(user_find.id)
      expect(user_find).to be_persisted
      expect(user_find.email).to eq("allan@allanbatista.com.br")
      expect(user_find.name).to eq("Allan Batista")
      expect(user_find.verified_email).to eq(true)
      expect(user_find.picture).to eq("https://placehold.it/200x200")
    end
  end
end
