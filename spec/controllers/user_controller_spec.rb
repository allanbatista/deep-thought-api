require 'rails_helper'

RSpec.describe UserController, type: :controller do
  before do
    Timecop.freeze(Time.local(2019))
    @user = User.create(email: "allan@allanbatista.com.br")
  end

  after do
    Timecop.return
  end

  context "GET /user" do
    it "should get user" do
      request.headers.merge!({ "Authentication" => @user.jwt })
      get :show

      expect(JSON.parse(response.body)).to eq({
        "_id"=>@user.id.to_s,
        "created_at"=>"2019-01-01T02:00:00.000Z",
        "email"=>"allan@allanbatista.com.br",
        "name"=>nil,
        "picture"=>nil,
        "updated_at"=>"2019-01-01T02:00:00.000Z",
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
