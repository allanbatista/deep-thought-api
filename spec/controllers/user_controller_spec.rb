require 'rails_helper'

RSpec.describe UserController, type: :controller do

  context "GET /user" do
    it "should get user" do
      request.headers.merge!({ "Authentication" =>  User.first.jwt })
      get :show

      expect(JSON.parse(response.body)).to eq({
        "id"=> User.first.id.to_s,
        "created_at"=> User.first.created_at.to_s,
        "email"=> User.first.email,
        "name"=>nil,
        "picture"=>nil,
        "updated_at"=>User.first.updated_at.to_s,
        "verified_email"=>nil
      })
    end

    it "should fail auth" do
      request.headers.merge!({ "Authentication" => "123" })
      get :show

      expect(response.status).to eq(401)
      expect(response.body).to eq('{"error_code":5,"message":"Authentication fail parse token"}')
    end
  end
end
