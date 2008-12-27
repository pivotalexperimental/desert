module Desert #:nodoc:
  module PluginMigrations
    class Migrator < ActiveRecord::Migrator
      class << self
        def current_version #:nodoc:
          result = ActiveRecord::Base.connection.select_one("SELECT version FROM #{schema_migrations_table_name} WHERE plugin_name = '#{current_plugin.name}' order by version desc")
          if result
            result['version'].to_i
          else
            # There probably isn't an entry for this plugin in the migration info table.
            0
          end
        end

        def get_all_versions
          ActiveRecord::Base.connection.select_values("SELECT version FROM #{schema_migrations_table_name} where plugin_name='#{current_plugin.name}'").map(&:to_i).sort
        end
      end

      def record_version_state_after_migrating(version)
        sm_table = self.class.schema_migrations_table_name

        if down?
          ActiveRecord::Base.connection.update("DELETE FROM #{sm_table} WHERE version = '#{version}' WHERE plugin_name = '#{current_plugin.name}'")
        else
          ActiveRecord::Base.connection.insert("INSERT INTO #{sm_table} (plugin_name, version) VALUES ('#{current_plugin.name}', '#{version}')")
        end
      end

      def migrated
        self.class.get_all_versions
      end
    end
  end
end
