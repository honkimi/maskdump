module Maskdump
  module MaskType
    class Base
      attr_reader :records, :column_name, :args
      def initialize(records, column_name, args)
        @records = records
        @column_name = column_name
        @args = args || {}
      end

      def mask
        raise NotImplementedError
      end
    end
  end
end
