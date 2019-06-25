class NamespacePermissionsController < AuthenticatedApplicationController
  before_action :set_namespace
  before_action :validate_authorization!
  before_action :set_namespace_permission, only: [:show, :update, :destroy]

  # GET /namespace_permissions
  def index
    @namespace_permissions = NamespacePermission.where(namespace: @namespace)

    render json: @namespace_permissions
  end

  # GET /namespace_permissions/1
  def show
    render json: @namespace_permission
  end

  # POST /namespace_permissions
  def create
    @namespace_permission = @namespace.permissions.new(params.permit(:user_id, :permissions => []))
    
    if @namespace_permission.save
      render json: @namespace_permission, status: :created, location: namespace_permission_path(@namespace, @namespace_permission)
    else
      render json: @namespace_permission.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /namespace_permissions/1
  def update
    if @namespace_permission.update(params.permit(:permissions => []))
      render json: @namespace_permission
    else
      render json: @namespace_permission.errors, status: :unprocessable_entity
    end
  end

  # DELETE /namespace_permissions/1
  def destroy
    @namespace_permission.destroy if @namespace_permission.present?
  end

  private
    def set_namespace
      @namespace = Namespace.find(params[:namespace_id])

      unless @namespace.present?
        return render json: { message: "namespace not found" }, status: 404
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_namespace_permission
      @namespace_permission = @namespace.permissions.find_by(_id: params[:id])

      unless @namespace_permission.present?
        return render json: { message: "permission not found" }, status: 404
      end
    end

    def validate_authorization!
      unless @namespace.permissions_for(current_user).include?("owner")
        return render json: { message: "only owner could manager namespace permissions" }, status: 403
      end
    end
end
