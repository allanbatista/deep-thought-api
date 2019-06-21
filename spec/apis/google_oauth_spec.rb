require 'rails_helper'

describe GoogleOauth do
  before do
    @client = GoogleOauth.new(ENV['DEEP_THOUGHT__AUTH__GOOGLE_CLIENT_ID'],
                              ENV['DEEP_THOUGHT__AUTH__GOOGLE_CLIENT_SECRET'],
                              "#{ENV['DEEP_THOUGHT__PROTOCOL']}://#{ENV['DEEP_THOUGHT__HOSTNAME']}:#{ENV['DEEP_THOUGHT__PORT']}/auth/sessions/google_callback")
  end

  context "#get_access_token" do
    it "should get currenct access_token" do
      stub_request(:post, "https://www.googleapis.com/oauth2/v4/token").
         with(
            body: {
              "client_id"=>@client.client_id, "client_secret"=>@client.secret_id, "code"=>"fake_token", "grant_type"=>"authorization_code", "redirect_uri"=>@client.callback_url
            },
            headers: {
       	      'Content-Type'=>'application/x-www-form-urlencoded',
            }).to_return(status: 200, body: '{"access_token":"fake_access_token"}')

      expect(@client.get_access_token("fake_token")).to eq('fake_access_token')
    end

    it "should raise error when fail auth" do
      stub_request(:post, "https://www.googleapis.com/oauth2/v4/token").
         with(
            body: {
              "client_id"=>@client.client_id, "client_secret"=>@client.secret_id, "code"=>"fake_token", "grant_type"=>"authorization_code", "redirect_uri"=>@client.callback_url
            },
            headers: {
       	      'Content-Type'=>'application/x-www-form-urlencoded',
            }).to_return(status: 400, body: '{"error":"message"}', headers: {})

      expect {
        @client.get_access_token("fake_token")
      }.to raise_error(StandardError)
    end
  end

  context "#userinfo" do
    it "should retrive userinfo" do
      stub_request(:get, "https://www.googleapis.com/oauth2/v1/userinfo?access_token=fake_access_token&alt=json").
        to_return(status: 200, body: fixture('apis/google_oauth/userinfo.json'))

      expect(@client.userinfo("fake_access_token")).to eq(JSON.parse(fixture('apis/google_oauth/userinfo.json')))
    end

    it "should fail auth to retrive userinfo" do
      stub_request(:get, "https://www.googleapis.com/oauth2/v1/userinfo?access_token=fake_access_token&alt=json").
        to_return(status: 400, body: '{"message":"error message"}')

      expect {
        @client.userinfo("fake_access_token")
      }.to raise_error(StandardError)
    end
  end
end
