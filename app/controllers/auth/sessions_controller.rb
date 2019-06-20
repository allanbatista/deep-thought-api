class Auth::SessionsController < ApplicationController
  def google_sing_in
    redirect_to $google_oauth.oauth_url
  end

  def google_callback
    userinfo = $google_oauth.userinfo($google_oauth.get_access_token(params[:code]))

    if userinfo.present?
      user = User.create_or_update_by_google_oauth(userinfo)
      return redirect_to(root_path(jwt: user.jwt))
    end

    render json: { message: "auth error" }, status: 400
  end

  def destroy
  end
end


# 4/bwFwactidOJzM1Yv_-HFRxFf-C_lkGPEAP81YLuiQ2fJPjPgmkN-ZZGLk5KMHpMFEvJmavB1IJh2xdANi9lxk3Q