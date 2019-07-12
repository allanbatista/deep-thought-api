class NamespaceAuthenticatedApplicationController < AuthenticatedApplicationController
  attr_reader :current_namespace

  before_action :set_namespace!
  before_action :authorizate!

  protected

  def minimum_required
    "viewer"
  end

  def set_namespace!
    if params[:namespace_id].present? || params[:namespace].present?
      @current_namespace = Namespace.find(params[:namespace_id] || params[:namespace])
    else
      @current_namespace ||= current_user.namespace
    end

    unless @current_namespace.present?
      return render json: { message: "namespace is required" }, status: 403
    end
  end

  MAP_PERMISSIONS = {
    "owner" => 3,
    "creator" => 2,
    "viewer" => 1
  }

  def authorizate!
    permission = @current_namespace.permissions_for(current_user).map { |p| MAP_PERMISSIONS[p] }.max || 0
    minimum = MAP_PERMISSIONS[minimum_required]
    method_minimum = request.method == "GET" ? 1 : 2
    
    unless permission >= minimum && permission >= method_minimum
      return render json: { message: "user has no enough permission to this namespace to execute this action" }, status: 403
    end
  end
end
