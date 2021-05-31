require 'maskdump/mask_type/base'

module Maskdump
  module MaskType
    class Replace < Base
      def mask
        records.each do |record|
          record[column_name] = process(record[column_name])
        end
      end

      private

      def process(_record)
        raise 'mask type :replace is requires args :to.' if args[:to].blank?
        args[:to]
      end
    end
  end
end
