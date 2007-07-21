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
  end
end