class AuthenticatedApplicationController < ApplicationController
  before_action :set_user!

  private

  def set_user!
    Thread.current[:user] = User.find_by_jwt(request.headers["Authentication"])

    unless Thread.current[:user].present?
      return render json: e("sessions.not_found"), status: 401
    end
  rescue JWT::ExpiredSignature => e
    render json: e("sessions.expired"), status: 401
  rescue JWT::VerificationError, JWT::DecodeError => e
    render json: e("sessions.invalid_token"), status: 401
  end

  protected

  def current_user
    @current_user ||= Thread.current[:user]
  end
end
