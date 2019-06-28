class QueryExecutorWorker
  include Worker

  def perform(query_id)
    query = Query.find(query_id)
    run(query) if query.present? && !query.complete?
  end

  protected

  def run(query)
    filename = "/tmp/#{id}.tsv"
    query.start!

    query.connection.client.execute(sql) do |result|
      query_result = query.connection.execute(sql)
      query_result.to_tsv(filename)
    end

    query.finish_with_success!(File.new(filename))
  rescue => e
    query.finish_with_error!("#{e.to_s}\n#{e.backtrace[1..10].join("\n")}")
  ensure
    File.delete(filename) if File.exist?(filename)
  end
end
