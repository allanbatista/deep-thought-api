class Connection::Result::Base
  def to_tsv(filename)
    ::CSV.open(filename, "wb+", col_sep: "\t") do |csv|
      csv << fields

      each do |row|
        csv << row
      end
    end
  end

  def to_a
    data = []
    each { |row| data << row }
    data
  end
end
