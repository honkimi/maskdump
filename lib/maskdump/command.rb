require 'thor'
require 'yaml'
require 'active_record'

module Maskdump
  class Command < Thor

    class_option :database,       type: :string, aliases: "-d", banner: 'database'
    class_option :user,           type: :array,  aliases: "-u", banner: 'user'
    class_option :password,       type: :string, aliases: "-p", banner: 'password'
    class_option :output,         type: :string, aliases: "-o", banner: 'output', required: true
    class_option :verbose,        type: :boolean, aliases: "-v", banner: ''
    class_option :'data-only',    type: :boolean, aliases: "-a", banner: ''

    desc "dump", "dump"
    def dump(yaml)
      @setting = Setting.new(yaml, options)
      connect_db
      if options[:'data-only']
        File.open(options[:output], 'w') {}
      else
        ActiveRecord::Tasks::DatabaseTasks.structure_dump(@setting.db_setting_hash, options[:output])
      end

      progress = 0
      tables_size = @setting.tables.size
      @setting.tables.each do |table_setting|
        progress += 1
        table = Table.new(table_setting[:name])
        if table.records.blank?
          puts "\e[0;37m(#{progress}/#{tables_size}) [#{table_setting[:name]}] Skipped. empty records.\e[0m" if options[:verbose]
          next
        end
        print "(#{progress}/#{tables_size}) \e[1;32m[#{table_setting[:name]}]\e[0m Start dump records..." if options[:verbose]
        masked_records = Mask.new(table.records, table_setting[:columns]).mask
        query = Query.generate_insert_statements(table.name, masked_records, table.columns, @setting)
        File.open(options[:output], 'a') do |f|
          f.puts "\n"
          f.puts query
          f.puts "\n"
        end
        puts " Finished." if options[:verbose]
      end
    end

    private

    def connect_db
      ActiveRecord::Base.establish_connection(@setting.db_setting_hash)
    end
  end
end
