class Connection::Result::Base
  def to_tsv(filename)
    ::CSV.open(filename, "w+", col_sep: "\t") do |csv|
      csv << fields

      each do |row|
        csv << row
      end
    end
  end

  def to_json(filename)
    File.open(filename, "w+") do |f|
      each do |row|
        f.write(to_h(row).to_json+"\n")
      end
    end
  end

  def to_a
    data = []
    each { |row| data << row }
    data
  end
end
