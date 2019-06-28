class Auth::SessionsController < ApplicationController  
  def google_sing_in
    redirect_to $google_oauth.oauth_url
  end

  def google_callback
    userinfo = $google_oauth.userinfo($google_oauth.get_access_token(params[:code]))
    
    if userinfo.present?
      return redirect_to build_callback_url(e("sessions.invalid_email")) unless authorizated_email?(userinfo["email"])

      user = User.create_or_update_by_google_oauth(userinfo)
      return redirect_to(build_callback_url(jwt: user.jwt))
    end
  
    redirect_to build_callback_url(e("sessions.oauth_refused"))
  rescue => e
    redirect_to build_callback_url(e("sessions.oauth_refused"))
  end

  private

  def authorizated_email?(email)
    email.match(self.class.email_match).present?
  end

  def self.email_match
    @email_match ||= Regexp.new(ENV['DEEP_THOUGHT__AUTH__EMAIL_DOMAIN_PATTERN'])
  end

  def build_callback_url(params)
    "#{endpoint_callback}?#{params.to_param}"
  end

  def endpoint_callback
    ENV['DEEP_THOUGHT__AUTH__CALLBACK_ENDPOINT']
  end
end
