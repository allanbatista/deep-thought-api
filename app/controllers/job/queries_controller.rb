class Job::QueriesController < NamespaceAuthenticatedApplicationController
  before_action :set_job_query, only: [:show, :update, :destroy]

  # GET /job/queries
  def index
    @job_queries = Job::Query.where(:namespace.in => current_namespace.childrens).order_by(created_at: :desc)

    render json: @job_queries
  end

  # GET /job/queries/1
  def show
    render json: @job_query
  end

  # POST /job/queries
  def create
    @job_query = Job::Query.new(job_query_params)

    if @job_query.save
      render json: @job_query, status: :created, location: @job_query
    else
      render json: @job_query.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /job/queries/1
  def update
    if @job_query.update(job_query_params)
      render json: @job_query
    else
      render json: @job_query.errors, status: :unprocessable_entity
    end
  end

  # DELETE /job/queries/1
  def destroy
    @job_query.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job_query
      @job_query = Job::Query.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def job_query_params
      params.require(:job_query).permit(:connection_id, :query, :variables)
    end
end
