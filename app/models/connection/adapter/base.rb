class Connection::Adapter::Base
  attr_reader :connection_params

  def initialize(connection_params)
    @connection_params = connection_params
  end
end
