class ActiveRecord::Migration
  module DesertMigration
    def migrate_plugin(plugin_name, version)
      plugin = find_plugin(plugin_name)
      Desert::PluginMigrations::Migrator.migrate_plugin(
        plugin,
        version
      )
    end

    protected
    def find_plugin(plugin_name)
      plugin = Desert::Manager.find_plugin(plugin_name.to_s)
      return plugin if plugin
      raise ArgumentError, "No plugin found named #{plugin_name}"
    end

    def table_exists?(table_name)
      vals = select_all("DESC #{table_name}")
      return true
    rescue ActiveRecord::StatementInvalid
      return false
    end

    def column_exists?(table_name, column_name)
      val = select_one("select #{column_name} from #{table_name}")
      return true
    rescue ActiveRecord::StatementInvalid
      return false
    end
    def table_exists?(table_name)
      ActiveRecord::Base.connection.tables.include? table_name
    end
  end
  extend DesertMigration
end