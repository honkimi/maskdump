require 'active_support'
require 'active_support/core_ext'
Dir["#{__dir__}/mask_type/*.rb"].each {|file| require file }

module Maskdump
  class Mask
    DIR_PREFIX = "maskdump/mask_type".freeze

    def initialize(records, column_settings)
      @column_settings = column_settings
      @records = records
    end

    def mask
      @column_settings.each_with_object(@records) do |column_setting, arr|
        begin
          arr = mask_type_klass(column_setting).new(arr, column_setting[:name], column_setting[:mask][:args]).mask
        rescue Exception => e
          raise e.exception("Failed mask in `#{column_setting[:name]}'. #{e.message}")
        end
      end
    end

    private

    def mask_type_klass(column_setting)
      klass = File.join(DIR_PREFIX, column_setting[:mask][:type]).classify.safe_constantize
      klass ? klass : custom_mask_type_klass(column_setting[:mask][:type])
    end

    def custom_mask_type_klass(method)
      paths = plugin_paths(method)
      raise "TODO" if paths.empty?
      require paths.first
      klass = plugin_path(method).classify.safe_constantize
      raise "TODO" unless klass
      klass
    end

    def plugin_paths(method)
      $LOAD_PATH.map do |load_path|
        path = File.join(load_path, plugin_path(method)) + ".rb"
        File.exist?(path) ? path : nil 
      end.compact
    end

    def plugin_path(method)
      "#{DIR_PREFIX}/plugin/#{method}"
    end
  end
end
