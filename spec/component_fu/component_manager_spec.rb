require "spec/spec_helper"

module ComponentFu
describe ComponentManager, :shared => true do
  it_should_behave_like "ComponentFu::ComponentManager fixture"
end

describe ComponentManager, ".method_missing" do
  it_should_behave_like "ComponentFu::ComponentManager"

  it "proxies to ComponentManager instance" do
    ComponentFu::ComponentManager.components.should === ComponentFu::ComponentManager.instance.components
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

  it "returns all of the load paths ordered by components and then Rails directories" do
    plugin_root = "#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy"
    @manager.components << plugin_root

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
end
