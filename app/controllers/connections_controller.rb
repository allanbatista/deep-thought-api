class ConnectionsController < ApplicationController
  attr_reader :clazz

  before_action :set_class_type, only: [:create]
  before_action :set_connection, only: [:show, :update, :destroy]

  # GET /connections
  def index
    @connections = Connection::Base.all

    render json: @connections
  end

  # GET /connections/1
  def show
    render json: @connection
  end

  # POST /connections
  def create
    @connection = clazz.new(connection_params)

    if @connection.save
      render json: @connection, status: :created, location: connection_path(@connection)
    else
      render json: @connection.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /connections/1
  def update
    if @connection.update(connection_params)
      render json: @connection
    else
      render json: @connection.errors, status: :unprocessable_entity
    end
  end

  # DELETE /connections/1
  def destroy
    @connection.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_connection
      @connection = clazz.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def connection_params
      params.permit(clazz.create_params)
    end

    def set_class_type
      if params[:type].present?
        @clazz ||= ["Connection", params[:type]].join("::").constantize
      else
        render json: {message: "type is required"}, status: :unprocessable_entity
      end
    end
end
