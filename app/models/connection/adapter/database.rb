class Connection::Adapter::Database
  attr_reader :client, :name

  def initialize(client, name)
    @client = client
    @name   = name
  end

  def tables
    @tables ||= @client.tables(self)
  end
  
  def table(table_name)
    tables.detect { |table| table.name == table_name.to_s.strip }
  end

  def as_json(options={})
    {
      "name" => name
    }
  end
end
