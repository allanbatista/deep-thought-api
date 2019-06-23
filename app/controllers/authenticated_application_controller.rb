class AuthenticatedApplicationController < ApplicationController
  before_action :set_user!
  before_action :ensure_user!

  private

  def set_user!
    @current_user = User.find_by_jwt(request.headers["Authentication"])
  rescue JWT::ExpiredSignature => e
    render json: {error_code: 1, message: I18n.t("error.1")}, status: 401
  rescue JWT::VerificationError, JWT::DecodeError => e
    render json: {error_code: 5, message: I18n.t("error.5")}, status: 401
  end

  def ensure_user!
    render json: {error_code: 2, message: I18n.t("error.2")}, status: 401 if current_user.blank?
  end

  protected

  def current_user
    @current_user
  end
end
