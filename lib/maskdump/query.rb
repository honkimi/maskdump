require 'maskdump/query/mysql'
require 'maskdump/query/postgresql'

module Maskdump
  module Query
    class << self
      def generate_insert_statements(table_name, records, columns, setting)
        klass(setting).new(table_name, records, columns).generate_insert_statements
      end

      private

      def klass(setting)
        case
        when setting.mysql?
          Mysql
        when setting.postgresql?
          Postgresql
        else
          raise "#{setting.rdbms} is unsupported."
        end
      end
    end
  end
end
