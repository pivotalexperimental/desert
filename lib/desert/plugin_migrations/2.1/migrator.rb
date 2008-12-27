module Desert #:nodoc:
  module PluginMigrations
    class Migrator < ActiveRecord::Migrator
      class << self
        def current_version #:nodoc:
          result = ActiveRecord::Base.connection.select_one("SELECT version FROM #{schema_migrations_table_name} WHERE plugin_name = '#{current_plugin.name}'")
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

        if ActiveRecord::Base.connection.select_one("SELECT version FROM #{self.class.schema_migrations_table_name} WHERE plugin_name = '#{current_plugin.name}'").nil?
          # We need to create the entry since it doesn't exist
          ActiveRecord::Base.connection.execute("INSERT INTO #{self.class.schema_migrations_table_name} (version, plugin_name) VALUES (#{version},'#{current_plugin.name}')")
        else
          ActiveRecord::Base.connection.update("UPDATE #{self.class.schema_migrations_table_name} SET version = #{version} WHERE plugin_name = '#{current_plugin.name}'")
        end
      end
      alias_method :record_version_state_after_migrating, :set_schema_version
    end
  end
end
