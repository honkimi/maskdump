require 'active_support'
require 'active_support/core_ext'
require 'maskdump/mask_type/tel'
require 'maskdump/mask_type/email'
require 'maskdump/mask_type/blackout'

module Maskdump
  class Mask
    DIR_PREFIX = "maskdump/mask_type".freeze

    def initialize(records, column_settings)
      @column_settings = column_settings
      @records = records
    end

    def mask
      @column_settings.each_with_object(@records) do |column_setting, arr|
        arr = mask_type_klass(column_setting).new(arr, column_setting[:name]).mask
      end
    end

    private

    def mask_type_klass(column_setting)
      klass = File.join(DIR_PREFIX, column_setting[:method]).classify.safe_constantize
      klass ? klass : custom_mask_type_klass(column_setting[:method])
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
