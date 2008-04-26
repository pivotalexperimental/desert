require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

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
end