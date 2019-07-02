class Query < Job
  belongs_to :connection

  def perform
    puts query.as_json
  end
end
