class UserController < AuthenticatedApplicationController
  def show
    render json: current_user
  end
end
