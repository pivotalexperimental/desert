require "spec/spec_helper"

module Desert
describe Plugin, "#==" do
  it_should_behave_like "Desert::ComponentManager fixture"

  it "returns true when the paths are ==" do
    plugin_root = "#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy"
    Plugin.new(plugin_root).should == Plugin.new(plugin_root)
  end
end

describe Plugin, "#migration_path" do
  it_should_behave_like "Desert::ComponentManager fixture"
  
  it "returns the migration path based on the passed in plugin path" do
    plugin_root = "#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy"
    @manager.register_plugin plugin_root
    plugin = @manager.find_plugin('acts_as_spiffy')
    plugin.migration_path.should == "#{File.expand_path(plugin_root)}/db/migrate"
  end
end
end