require 'maskdump/mask_type/base'

module Maskdump
  module MaskType
    class Email < Base
      def mask
        records.each do |record|
          record[column_name] = process(record[column_name])
        end
      end

      private

      def process(record)
        return record unless record.is_a?(String)
        _, domain = record.split("@")
        username = Digest::MD5.hexdigest(counter.to_s)
        "#{username}@#{domain}"
      end
    end
  end
end
