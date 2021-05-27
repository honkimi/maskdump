module Maskdump
  module Query
    class Base
      def initialize(table_name, records, columns)
        @table_name = table_name
        @records = records
        @columns = columns
      end

      def generate_insert_statements
        raise NotImplementedError
      end
    end
  end
end
