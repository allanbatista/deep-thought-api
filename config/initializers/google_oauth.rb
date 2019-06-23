$google_oauth = GoogleOauth.new(ENV['DEEP_THOUGHT__AUTH__GOOGLE_CLIENT_ID'],
                                ENV['DEEP_THOUGHT__AUTH__GOOGLE_CLIENT_SECRET'],
                                "#{ENV['DEEP_THOUGHT__PROTOCOL']}://#{ENV['DEEP_THOUGHT__HOSTNAME']}:#{ENV['DEEP_THOUGHT__PORT']}/auth/sessions/google_callback")