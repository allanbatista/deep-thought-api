class NamespacePermissionsController < NamespaceAuthenticatedApplicationController
  before_action :set_namespace_permission, only: [:show, :update, :destroy]

  # GET /namespaces/:namespace_id/permissions
  def index
    @namespace_permissions = NamespacePermission.where(namespace: current_namespace)

    render json: @namespace_permissions
  end

  # GET /namespaces/:namespace_id/permissions/:id
  def show
    render json: @namespace_permission
  end

  # POST /namespaces/:namespace_id/permissions
  def create
    @namespace_permission = current_namespace.permissions.new(params.permit(:user_id, :permissions => []))
    
    if @namespace_permission.save
      render json: @namespace_permission, status: :created, location: namespace_permission_path(current_namespace, @namespace_permission)
    else
      render json: e("http.unprocessable_entity", errors: @namespace_permission.errors), status: :unprocessable_entity
    end
  end

  # PATCH/PUT /namespaces/:namespace_id/permissions/:id
  def update
    if @namespace_permission.update(params.permit(:permissions => []))
      render json: @namespace_permission
    else
      render json: e("http.unprocessable_entity", errors: @namespace_permission.errors), status: :unprocessable_entity
    end
  end

  # DELETE /namespaces/:namespace_id/permissions/:id
  def destroy
    @namespace_permission.destroy
  end

  protected

  def minimum_required
    "owner"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_namespace_permission
      @namespace_permission = current_namespace.permissions.find_by(_id: params[:id])

      unless @namespace_permission.present?
        return render json: { message: "permission not found" }, status: 404
      end
    end
end
