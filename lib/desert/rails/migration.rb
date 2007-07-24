class ActiveRecord::Migration
  module DesertMigration
    def migrate_plugin(plugin_name, version)
      plugin = find_plugin(plugin_name)
      PluginAWeek::PluginMigrations::Migrator.migrate_plugin(
        plugin,
        version
      )
    end

    def schema_version_equivalent_to(plugin_name, version)
      plugin = find_plugin(plugin_name)
      PluginAWeek::PluginMigrations::Migrator.current_plugin = plugin
      PluginAWeek::PluginMigrations::Migrator.allocate.set_schema_version(version)
    end

    protected
    def find_plugin(plugin_name)
      plugin = Desert::Manager.find_plugin(plugin_name)
      return plugin if plugin
      raise ArgumentError, "No plugin found named #{plugin_name}"
    end
  end
  extend DesertMigration
end