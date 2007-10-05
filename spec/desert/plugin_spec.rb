require "spec/spec_helper"

module Desert
describe Plugin, "#==" do
  it_should_behave_like "Desert::Manager fixture"

  it "returns true when the paths are ==" do
    plugin_root = "#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy"
    Plugin.new(plugin_root).should == Plugin.new(plugin_root)
  end
end

describe Plugin, "#migration_path" do
  it_should_behave_like "Desert::Manager fixture"
  
  it "returns the migration path based on the passed in plugin path" do
    plugin_root = "#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy"
    @manager.register_plugin plugin_root
    plugin = @manager.find_plugin('acts_as_spiffy')
    plugin.migration_path.should == "#{File.expand_path(plugin_root)}/db/migrate"
  end
end

describe Plugin, "#controllers_path" do
  it_should_behave_like "Desert::Manager fixture"

  it "returns the controller path base on the passed in plugin" do
    plugin_root = "#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy"
    @manager.register_plugin plugin_root
    plugin = @manager.find_plugin('acts_as_spiffy')
    plugin.controllers_path.should == "#{File.expand_path(plugin_root)}/app/controllers"
  end
end

describe Plugin, '#up_to_date?' do
  it_should_behave_like "Desert::Manager fixture"

  before do
    @mock_migrator = Object.new
    stub(@mock_migrator).latest_version.returns(1)
    stub(PluginAWeek::PluginMigrations::Migrator).new { @mock_migrator }
  end

  it "returns true if the schema version of the plugin equals the latest migration number" do
    stub(@mock_migrator).current_version.returns(1)
    plugin = Plugin.new("#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy")
    plugin.should be_up_to_date
  end

  it "returns false if the schema version of the plugin is less than the latest migration number" do
    stub(@mock_migrator).current_version.returns(0)
    plugin = Plugin.new("#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy")
    plugin.should_not be_up_to_date
  end

  it "should not affect the current plugin of the PluginAWeek Migrator" do
    my_current_plugin = Object.new
    PluginAWeek::PluginMigrations::Migrator.current_plugin = my_current_plugin
    stub(@mock_migrator).current_version.returns(1)
    plugin = Plugin.new("#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy")
    plugin.should be_up_to_date
    PluginAWeek::PluginMigrations::Migrator.current_plugin.should == my_current_plugin
  end
end
end