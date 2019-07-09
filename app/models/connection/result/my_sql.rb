class Connection::Result::MySQL < Connection::Result::Base
  def initialize(results)
    @results = results
  end

  def fields
    @fields ||= @results.fields
  end

  def each
    @results.each(stream: true, :as => :array) do |row|
      yield(row)
    end
  end

  def to_h(row)
    Hash[fields.zip(row)]
  end
end
