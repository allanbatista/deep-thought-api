module Connection
  module Result
    class Base
      def to_tsv(filename)
        ::CSV.open(filename, "wb+", col_sep: "\t") do |csv|
          csv << fields

          each do |row|
            csv << row
          end
        end
      end
    end

    class MySQL < Base
      def initialize(results)
        @results = results
      end

      def fields
        @results.fields
      end

      def each
        @results.each(stream: true, :as => :array) do |row|
          yield(row)
        end
        nil
      end
    end
  end
end
