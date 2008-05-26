require File.expand_path("#{File.dirname(__FILE__)}/../../spec_helper")

describe ActiveRecord::Migration::DesertMigration do
  attr_reader :fixture
  before do
    @fixture = Object.new
    fixture.extend ActiveRecord::Migration::DesertMigration
  end

  it "test_plugin_for__with_invalid_name__raises_exception" do
    proc do
      path_for_plugin("non_existent_plugin")
    end.should raise_error
  end

  it "test_migrate_plugin" do
    fake_plugin = "i am a plugin"
    stub(Desert::Manager).find_plugin("my_plugin") {fake_plugin}
    mock(PluginAWeek::PluginMigrations::Migrator).migrate_plugin(fake_plugin, 3)

    fixture.migrate_plugin("my_plugin", 3)
  end

  it "test_schema_version_equivalent_to" do
    fake_plugin = "i am a plugin"
    fake_migrator = "fake migrator"
    stub(Desert::Manager).find_plugin("my_plugin") {fake_plugin}
    
    mock(PluginAWeek::PluginMigrations::Migrator).allocate {fake_migrator}
    mock(fake_migrator).set_schema_version(3)

    fixture.schema_version_equivalent_to("my_plugin", 3)
    PluginAWeek::PluginMigrations::Migrator.current_plugin.should == fake_plugin
  end
end
