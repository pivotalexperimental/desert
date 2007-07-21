module PluginAWeek #:nodoc:
  module PluginMigrations
    class << self
      # Migrate the database through scripts in plugin_xyz/db/migrate. Specify
      # target plugins through plugin_names.  The version can only be used when
      # targeting specific plugins.
      def migrate(plugin_names = nil, version = nil)
        version = version.to_i if version
        Rails.plugins.find_by_names(plugin_names).each {|plugin| plugin.migrate(version)}
      end
      
      # Load plugin fixtures into the current environment's database.  Load
      # fixtures for a specific plugin using plugin_names, specific fixtures
      # using fixtures
      def load_fixtures(plugin_names = nil, fixtures = nil)
        require 'active_record/fixtures'
        Rails.plugins.find_by_names(plugin_names).each {|plugin| plugin.load_fixtures(fixtures)}
      end
    end
    
    # Responsible for migrating plugins.  PluginAWeek::PluginMigrations.Migrator.current_plugin
    # indicates which plugin is currently being migrated
    class Migrator < ActiveRecord::Migrator
      # We need to be able to set the current plugin being migrated.
      cattr_accessor :current_plugin
      
      class << self
        # Runs the migrations from a plugin, up (or down) to the version given
        def migrate_plugin(plugin, version = nil)
          self.current_plugin = plugin
          migrate(plugin.migration_path, version)
        end
        
        def schema_info_table_name #:nodoc:
          ActiveRecord::Base.table_name_prefix + 'plugin_schema_info' + ActiveRecord::Base.table_name_suffix
        end
        
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
    end
  end
end