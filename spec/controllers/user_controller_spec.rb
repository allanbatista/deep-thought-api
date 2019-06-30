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

    it "should set invalid token" do
      request.headers.merge!({ "Authentication" => "123" })
      get :show

      expect(response.status).to eq(401)
      expect(response.body).to eq("{\"message\":\"Invalid Token\",\"code\":105}")
    end

    it "should cant find user" do
      request.headers.merge!({ "Authentication" => User.first.jwt })
      User.first.destroy
      get :show

      expect(response.status).to eq(401)
      expect(response.body).to eq("{\"message\":\"Can't find User\",\"code\":102}")
    end

    it "should fail auth when expire token" do
      request.headers.merge!({ "Authentication" => User.first.jwt(1.seconds.from_now) })

      sleep 1
      get :show

      expect(response.status).to eq(401)
      expect(response.body).to eq("{\"message\":\"Authentication Expired\",\"code\":101}")
    end
  end
end
