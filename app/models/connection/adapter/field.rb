class Connection::Adapter::Field
  attr_reader :name, :type

  def initialize(name, type)
    @name = name
    @type = type
  end

  def ==(other)
    return self.as_json == other.as_json
  end
end
