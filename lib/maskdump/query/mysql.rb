require 'maskdump/query/base'

module Maskdump
  module Query
    class Mysql < Base
      def generate_insert_statements
        "INSERT INTO #{@table_name} (#{@columns.map{|c|"`#{c}`"}.join(", ")}) VALUES #{value_clause};"
      end

      private

      def value_clause
        @records.map do |record|
          "(#{cast(record).join(", ")})"
        end.join(", ")
      end

      def cast(record)
        record.values.map do |value|
          if value.is_a?(Numeric)
            value
          elsif value.nil?
            'null'
          else
            "'#{value}'"
          end
        end
      end
    end
  end
end
