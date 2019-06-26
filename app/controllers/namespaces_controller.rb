class NamespacesController < AuthenticatedApplicationController
  before_action :set_namespace, only: [:show, :update, :destroy]
  before_action :authorizate_owner!, only: [:update, :destroy]

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
    @namespace = Namespace.new(params.permit(:namespace_id, :name))

    if @namespace.save
      @namespace.permissions.create(user: current_user, permissions: ["owner"])

      render json: @namespace, status: :created, location: @namespace
    else
      render json: @namespace.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /namespaces/1
  def update
    if @namespace.update(params.permit(:namespace_id, :name))
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

    def authorizate_owner!
      unless @namespace.present? && @namespace.permissions_for(current_user).include?("owner")
        return render json: { message: "only owner could manager this resource" }, status: 403
      end
    end
end
