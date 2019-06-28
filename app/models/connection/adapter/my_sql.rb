class Connection::Adapter::MySQL < Connection::Adapter::Base
  def connect?
    connection = new_connection()
    connection.close rescue nil
    return true
  rescue Mysql2::Error::ConnectionError => e
    return false
  end

  def execute(sql)
    connection = new_connection()
    result = Connection::Result::MySQL.new(connection.query(sql))
    yield(result)
  ensure
    connection.close
  end

  private

  def new_connection
    Mysql2::Client.new(connection_params)
  end
end
