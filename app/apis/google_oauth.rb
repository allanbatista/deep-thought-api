class GoogleOauth
  attr_reader :client_id, :secret_id, :callback_url

  def initialize(client_id, secret_id, callback_url)
    @client_id = client_id
    @secret_id = secret_id
    @callback_url = callback_url
  end

  def oauth_url
    params = {
      client_id: client_id,
      redirect_uri: callback_url,
      scope: "email",
      prompt: "select_account",
      response_type: "code",
      include_granted_scopes: "true",
      access_type: "offline"
    }

    "https://accounts.google.com/o/oauth2/v2/auth?#{params.to_param}"
  end

  def get_access_token(code)
    data = {
      code: code,
      client_id: client_id,
      client_secret: secret_id,
      grant_type: 'authorization_code',
      redirect_uri: callback_url
    }
    
    response = Faraday.post("https://www.googleapis.com/oauth2/v4/token") do |f|
      f.headers['Content-Type'] = 'application/x-www-form-urlencoded'
      f.body = URI.encode_www_form(data)
    end
    
    raise StandardError.new(response.body) if response.status >= 400
    
    JSON.parse(response.body)['access_token']
  end

  def userinfo(access_token)
    response = Faraday.get("https://www.googleapis.com/oauth2/v1/userinfo?alt=json&access_token=#{access_token}")

    raise StandardError.new(response.body) if response.status >= 400

    JSON.parse(response.body)
  end
end
