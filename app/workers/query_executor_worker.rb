class QueryExecutorWorker
  include Worker

  def perform(query_id)
    query = Query.find(query_id)
    run(query) if query.present? && !query.complete?
  end

  protected

  def run(query)
    filename = "/tmp/#{id}.tsv"
    query_result = query.connection.execute(sql)
    query_result.to_tsv(filename)
    query.update(result: filename, status: "done")
  rescue => e
    query.update(status: "fail", message: "#{e.to_s}\n#{e.backtrace.join("\n")}")
  ensure
    File.delete(filename) if File.exist?(filename)
  end
end
