require "spec/spec_helper"

module ComponentFu
describe ComponentManager, :shared => true do
  it_should_behave_like "ComponentFu::ComponentManager fixture"
end

describe ComponentManager, ".method_missing" do
  it_should_behave_like "ComponentFu::ComponentManager"

  it "proxies to ComponentManager instance" do
    ComponentFu::ComponentManager.plugins.should === ComponentFu::ComponentManager.instance.plugins
  end
end

describe ComponentManager, "#instance" do
  it_should_behave_like "ComponentFu::ComponentManager"

  it "is a ComponenManager object" do
    ComponentFu::ComponentManager.instance.is_a?(ComponentFu::ComponentManager).should == true
  end

  it "is a singleton" do
    ComponentFu::ComponentManager.instance.should === ComponentFu::ComponentManager.instance
  end
end

describe ComponentManager, "#load_paths" do
  it_should_behave_like "ComponentFu::ComponentManager"

  it "returns all of the load paths ordered by plugins and then Rails directories" do
    plugin_root = "#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy"
    @manager.plugins << plugin_root

    @manager.load_paths.should == [
      "#{plugin_root}/app",
      "#{plugin_root}/app/models",
      "#{plugin_root}/app/controllers",
      "#{plugin_root}/app/helpers",
      "#{plugin_root}/lib",
      "#{RAILS_ROOT}/app",
      "#{RAILS_ROOT}/app/models",
      "#{RAILS_ROOT}/app/controllers",
      "#{RAILS_ROOT}/app/helpers",
      "#{RAILS_ROOT}/lib",
    ]
  end
end

describe ComponentManager, "#directory_on_load_path?" do
  it_should_behave_like "ComponentFu::ComponentManager"

  it "returns true when there is a directory on the Rails load path" do
    ComponentFu::ComponentManager.
      directory_on_load_path?("spiffy").should be_true
  end

  it "returns false when there is a file but no directory on load path" do
    ComponentFu::ComponentManager.
      directory_on_load_path?("spiffy_helper").should be_false
  end

  it "returns false when there is no directory on load path" do
    ComponentFu::ComponentManager.
      directory_on_load_path?("i_dont_exist").should be_false
  end
end

describe ComponentManager, "#plugin_path" do
  it_should_behave_like "ComponentFu::ComponentManager"

  before do
    @plugin_root = "#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy"
    @manager.plugins << @plugin_root
  end

  it "returns the path for the passed in plugin name" do
    @manager.plugin_path('acts_as_spiffy').should == "#{@plugin_root}"
  end
end
end