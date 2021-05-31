require 'maskdump/query/base'

module Maskdump
  module Query
    class Postgresql < Base
      def generate_insert_statements
        "INSERT INTO #{@table_name} (#{@columns.join(", ")}) VALUES #{value_clause};"
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
          elsif !!value === value
            value.to_s
          else
            "'#{value}'"
          end
        end
      end
    end
  end
end
