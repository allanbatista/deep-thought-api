class ConnectionsController < NamespaceAuthenticatedApplicationController
  attr_reader :clazz

  before_action :set_class_type, only: [:create]
  before_action :set_connection, only: [:show, :update, :destroy]

  # GET /connections
  def index
    @connections = Connection::Base.where(namespace_id: @namespace)

    render json: @connections
  end

  # GET /connections/1
  def show
    render json: @connection
  end

  # POST /connections
  def create
    @connection = clazz.new(connection_params)
    @connection.namespace ||= current_user.namespace

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
    if @connection.present?
      @connection.destroy

      render nothing: true, status: 204
    end
  end

  # GET /connections/types
  def types
    types = Connection::Base.descendants.map do |clazz|
      {
        type: clazz.type,
        fields: clazz.create_params
      }
    end

    render json: types
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_connection
      @connection = Connection::Base.find_by(_id: params[:id], namespace: @namespace)

      unless @connection.present?
        return render json: { message: "Not Found" }, status: 404 unless @connection.present?
      end
    end

    # Only allow a trusted parameter "white list" through.
    def connection_params
      if clazz.present?
        params.permit(clazz.permit_params)
      else
        params.permit(@connection.class.permit_params)
      end
    end

    def set_class_type
      if params[:type].present?
        @clazz ||= ["Connection", params[:type]].join("::").constantize
      else
        render json: {message: "type is required"}, status: :unprocessable_entity
      end
    end
end
