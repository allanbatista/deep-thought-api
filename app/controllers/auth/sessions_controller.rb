class Auth::SessionsController < ApplicationController
  EMAIL_MATCH = Regexp.new(ENV['DEEP_THOUGHT__AUTH__EMAIL_DOMAIN_PATTERN'])
  
  def google_sing_in
    redirect_to $google_oauth.oauth_url
  end

  def google_callback
    userinfo = $google_oauth.userinfo($google_oauth.get_access_token(params[:code]))
    
    if userinfo.present?
      return redirect_to root_path(error_code: 4, message: t("error.4")) unless authorizated_email?(userinfo["email"])

      user = User.create_or_update_by_google_oauth(userinfo)
      return redirect_to(root_path(jwt: user.jwt))
    end
  
  rescue => e
    redirect_to root_path(error_code: 3, message: t("error.3"))
  end

  private

  def authorizated_email?(email)
    email.match(EMAIL_MATCH).present?
  end
end