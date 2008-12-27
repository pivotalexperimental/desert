module Desert #:nodoc:
  module PluginMigrations
    # Responsible for migrating plugins.  PluginMigrations.Migrator.current_plugin
    # indicates which plugin is currently being migrated
    class Migrator < ActiveRecord::Migrator
      # We need to be able to set the current plugin being migrated.
      cattr_accessor :current_plugin

      class << self
        # Runs the migrations from a plugin, up (or down) to the version given
        def migrate_plugin(plugin, version = nil)
          self.current_plugin = plugin
          if ActiveRecord::Base.connection.respond_to?(:initialize_schema_migrations_table)
            ActiveRecord::Base.connection.initialize_schema_migrations_table
          end
          migrate(plugin.migration_path, version)
        end

        def schema_info_table_name #:nodoc:
          ActiveRecord::Base.table_name_prefix + 'plugin_schema_info' + ActiveRecord::Base.table_name_suffix
        end
        
        def schema_migrations_table_name
          ActiveRecord::Base.table_name_prefix + 'plugin_schema_migrations' + ActiveRecord::Base.table_name_suffix
        end
      end
    end
  end
end