require 'rails_helper'

RSpec.describe Auth::SessionsController, type: :controller do
  context "GET /auth/sessions/google_callback" do
    it "should create and authenticate user" do
      expect_any_instance_of(User).to receive(:jwt) { "1" }

      stub_request(:post, "https://www.googleapis.com/oauth2/v4/token")
        .to_return(status: 200, body: '{"access_token": "fake_access_token"}')

      stub_request(:get, "https://www.googleapis.com/oauth2/v1/userinfo?access_token=fake_access_token&alt=json")
        .to_return(status: 200, body: fixture('apis/google_oauth/userinfo.json'))

      expect(User.count).to eq(0)

      get :google_callback, params: { code: "123" }
      expect(subject).to redirect_to("/?jwt=1")
      
      expect(User.count).to eq(1)
    end

    it "should fail authenticate" do
      stub_request(:post, "https://www.googleapis.com/oauth2/v4/token")
        .to_return(status: 400, body: '{"message": "error"}')

      get :google_callback, params: { code: "123" }
      expect(subject).to redirect_to("/?error_code=3&message=Authentication+Google+Refused")
      
      expect(User.count).to eq(0)
    end
  end
end