class HomeController < ApplicationController
  def index
    render json: params
  end
end
