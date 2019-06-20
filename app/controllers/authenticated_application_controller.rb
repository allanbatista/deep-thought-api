class AuthenticatedApplicationController < ApplicationController
  before_action :set_user!
  before_action :ensure_user!

  private

  def set_user!
    @current_user = User.find_by_jwt(request.headers["Authentication"])
  rescue JWT::ExpiredSignature => e
    redirect_to $google_oauth.oauth_url
  end

  def ensure_user!
    redirect_to $google_oauth.oauth_url unless current_user.present?
  end

  protected

  def current_user
    @current_user
  end
end