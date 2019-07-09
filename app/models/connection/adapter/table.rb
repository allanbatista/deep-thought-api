class Connection::Adapter::Table
  attr_reader :client, :database, :name

  def initialize(client, database, name)
    @client = client
    @database = database
    @name   = name
  end

  def describe
    @describe ||= client.describe(database, self)
  end

  def as_json(options={})
    {
      name: name
    }
  end
end
