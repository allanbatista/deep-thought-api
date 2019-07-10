##
# QueryTemplate integrate with ruby code
class Connection::QueryTemplate
  class << self
    def format(sql, variables={})
      ERB.new(sql, 1).result(OpenStruct.new(variables).instance_eval { binding })
    end
  end
end
