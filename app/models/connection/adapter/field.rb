class Connection::Adapter::Field
  attr_reader :client, :database, :table, :name, :type

  def initialize(client, database, table, name, type)
    @client = client
    @database = database
    @table = table
    @name   = name
  end
end
