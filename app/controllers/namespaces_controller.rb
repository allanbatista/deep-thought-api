class NamespacesController < AuthenticatedApplicationController
  before_action :set_namespace, only: [:show, :update, :destroy]
  before_action :validate_authorization!, only: [:update, :destroy]

  # GET /namespaces
  def index
    @namespaces = Namespace.all

    render json: @namespaces
  end

  # GET /namespaces/1
  def show
    render json: @namespace
  end

  # POST /namespaces
  def create
    @namespace = Namespace.new(namespace_params)

    if @namespace.save
      @namespace.permissions.create(user: current_user, permissions: ["owner"])

      render json: @namespace, status: :created, location: @namespace
    else
      render json: @namespace.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /namespaces/1
  def update
    if @namespace.update(namespace_params)
      render json: @namespace
    else
      render json: @namespace.errors, status: :unprocessable_entity
    end
  end

  # DELETE /namespaces/1
  def destroy
    @namespace.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_namespace
      @namespace = Namespace.find(params[:id])

      unless @namespace.present?
        return render json: { message: "namespace not found" }, status: 404
      end
    end

    # Only allow a trusted parameter "white list" through.
    def namespace_params
      params.permit(:name, :namespace_id)
    end
end
