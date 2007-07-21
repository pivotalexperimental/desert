class Plugin
  # The location of the plugin's migrations
  def migration_path
    "#{root}/db/migrate"
  end
  
  # Migrate this plugin to the given version
  def migrate(version = nil)
    PluginAWeek::PluginMigrations::Migrator.migrate_plugin(self, version)
  end
  
  # The location of the plugin's fixtures
  def fixtures_path
    "#{root}/test/fixtures"
  end
  
  # The paths of all of the plugin's fixtures
  def fixtures(names = nil)
    names ||= '*'
    Dir["#{fixtures_path}/{#{names}}.{yml,csv}"].sort
  end
  
  # Loads the fixtures for the plugin
  def load_fixtures(*args)
    fixtures(*args).each do |fixture|
      Fixtures.create_fixtures(File.dirname(fixture), File.basename(fixture, '.*'))
    end
  end
end