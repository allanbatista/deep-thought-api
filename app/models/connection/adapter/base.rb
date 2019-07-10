class Connection::Adapter::Base
  attr_reader :connection_params

  def initialize(connection_params)
    @connection_params = connection_params
  end

  def database(database_name)
    databases.detect { |database| database.name == database_name.to_s.strip }
  end

  # :nocov:
  ##
  # Should list databases
  #
  # @return Connection::Adapter::Database[]
  def databases
    raise NotImplementedError
  end

  ##
  # Should list tables from database
  #
  # database => Connection::Adapter::Database
  #
  # @return Connection::Adapter::Table[]
  def tables(database)
    raise NotImplementedError
  end

  ##
  # Should describe a table
  #
  # database => Connection::Adapter::Database
  # table => Connection::Adapter::Table
  #
  # @return Connection::Adapter::Field[]
  def describe(database, table)
    raise NotImplementedError
  end
  # :nocov:
end
