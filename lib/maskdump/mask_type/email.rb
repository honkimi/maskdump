require 'maskdump/mask_type/base'

module Maskdump
  module MaskType
    class Email < Base
      def initialize(records, column_name, args)
        super
        @counter = 0
      end

      def mask
        records.each do |record|
          record[column_name] = process(record[column_name])
          @counter += 1
        end
      end

      private

      def process(record)
        return record unless record.is_a?(String)
        domain = args[:domain].present? ? args[:domain] : 'example.com'
        digest = Digest::MD5.hexdigest(@counter.to_s)
        "#{digest}@#{domain}"
      end
    end
  end
end
