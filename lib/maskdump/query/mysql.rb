require 'maskdump/query/base'

module Maskdump
  module Query
    class Mysql < Base
      def generate_insert_statements
        "INSERT INTO #{@table_name} (#{@columns.join(", ")}) VALUES #{value_clause};"
      end

      private

      def value_clause
        @records.map do |record|
          "(#{quote(record).join(", ")})"
        end.join(", ")
      end

      def quote(record)
        record.values.map{ |value| "'#{value}'" }
      end
    end
  end
end
