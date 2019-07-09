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

  def databases
    @databases = []

    execute("SHOW DATABASES;") do |result|
      @databases = result.map { |row| Connection::Adapter::Database.new(self, row[0]) }
    end

    @databases
  end

  def tables(database)
    @tables = []

    execute("SHOW TABLES FROM `#{database.name}`;") do |result|
      @tables = result.map { |row| Connection::Adapter::Table.new(self, database, row[0]) }
    end

    @tables
  end

  def describe(database, table)
    @describe = []

    execute("DESCRIBE `#{database.name}`.`#{table.name}`;") do |result|
      @describe = result.map { |row| Connection::Adapter::Field.new(row[0], row[1]) }
    end

    @describe
  end

  private

  def new_connection
    Mysql2::Client.new(connection_params)
  end
end
