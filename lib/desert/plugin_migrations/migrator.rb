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
        alias_method :schema_migrations_table_name, :schema_info_table_name

        def current_version #:nodoc:
          result = ActiveRecord::Base.connection.select_one("SELECT version FROM #{schema_info_table_name} WHERE plugin_name = '#{current_plugin.name}'")
          if result
            result['version'].to_i
          else
            # There probably isn't an entry for this plugin in the migration info table.
            0
          end
        end
      end

      def set_schema_version(version)
        version = down? ? version.to_i - 1 : version.to_i

        if ActiveRecord::Base.connection.select_one("SELECT version FROM #{self.class.schema_info_table_name} WHERE plugin_name = '#{current_plugin.name}'").nil?
          # We need to create the entry since it doesn't exist
          ActiveRecord::Base.connection.execute("INSERT INTO #{self.class.schema_info_table_name} (version, plugin_name) VALUES (#{version},'#{current_plugin.name}')")
        else
          ActiveRecord::Base.connection.update("UPDATE #{self.class.schema_info_table_name} SET version = #{version} WHERE plugin_name = '#{current_plugin.name}'")
        end
      end
      alias_method :record_version_state_after_migrating, :set_schema_version


      def migrated
        current_plugin_version = self.class.current_version
        (1..current_plugin_version).to_a
      end
    end
  end
end