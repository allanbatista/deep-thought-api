class ConnectionsController < NamespaceAuthenticatedApplicationController
  attr_reader :clazz

  before_action :set_class_type, only: [:create]
  before_action :set_connection, only: [:show, :update, :destroy, :databases, :tables, :describe]

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
      render json: e("http.unprocessable_entity", errors: @connection.errors), status: :unprocessable_entity
    end
  end

  # PATCH/PUT /connections/1
  def update
    if @connection.update(connection_params)
      render json: @connection
    else
      render json: e("http.unprocessable_entity", errors: @connection.errors), status: :unprocessable_entity
    end
  end

  # DELETE /connections/1
  def destroy
    @connection.destroy
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

  # GET /connections/:connection_id/databases
  def databases
    render json: @connection.client.databases
  end

  # GET /connections/:connection_id/:database_name/tables
  def tables
    render json: @connection.client.database(params[:database_name]).tables
  end

  # GET /connections/:connection_id/:database_name/:tables
  def describe
    render json: @connection.client.database(params[:database_name]).table(params[:table_name]).describe
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_connection
      @connection = Connection::Base.find_by(_id: params[:id] || params[:connection_id], namespace: @namespace)

      unless @connection.present?
        return render json: e("http.not_found"), status: 404 unless @connection.present?
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
        render json: e("connections.required_type"), status: :unprocessable_entity
      end
    end
end
