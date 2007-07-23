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

describe ComponentManager, "#register_plugin" do
  it_should_behave_like "ComponentFu::ComponentManager"

  before do
    @plugin_root = "#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy"
    @plugin = @manager.register_plugin(@plugin_root)
  end

  it "creates a Plugin object based on the path" do
    @plugin.path.should == File.expand_path(@plugin_root)
    @plugin.name.should == "acts_as_spiffy"
  end

  it "adds the plugin to the list" do
    @manager.plugins.should == [@plugin]
  end

  it "does not add plugin when plugin is already on list" do
    @plugin = @manager.register_plugin(@plugin_root)
    @manager.plugins.should == [@plugin]
  end
end

describe ComponentManager, "#load_paths" do
  it_should_behave_like "ComponentFu::ComponentManager"

  it "returns all of the load paths ordered by plugins and then Rails directories" do
    plugin_root = File.expand_path("#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy")
    @manager.register_plugin plugin_root
    rails_root = File.expand_path(RAILS_ROOT)

    @manager.load_paths.should == [
      "#{plugin_root}/app",
      "#{plugin_root}/app/models",
      "#{plugin_root}/app/controllers",
      "#{plugin_root}/app/helpers",
      "#{plugin_root}/lib",
      "#{rails_root}/app",
      "#{rails_root}/app/models",
      "#{rails_root}/app/controllers",
      "#{rails_root}/app/helpers",
      "#{rails_root}/lib",
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

describe ComponentManager, "#find_plugin" do
  it_should_behave_like "ComponentFu::ComponentManager"

  before do
    @plugin_root = "#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy"
    @manager.register_plugin @plugin_root
  end

  it "returns true when registered plugin name passed in" do
    @manager.find_plugin('acts_as_spiffy').
      should == Plugin.new(@plugin_root)
  end

  it "returns false when nonregistered plugin name passed in" do
    @manager.find_plugin('acts_as_absent').
      should == nil
  end

  it "returns true when registered plugin directory passed in" do
    @manager.find_plugin(@plugin_root).
      should == Plugin.new(@plugin_root)
  end

  it "returns false when nonregistered plugin directory passed in" do
    @manager.find_plugin("#{RAILS_ROOT}/vendor/plugins/non_existent").
      should == nil
  end
end

describe ComponentManager, "#plugin_exists?" do
  it_should_behave_like "ComponentFu::ComponentManager"

  before do
    @plugin_root = "#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy"
    @manager.register_plugin @plugin_root
  end

  it "returns true when registered plugin name passed in" do
    @manager.plugin_exists?('acts_as_spiffy').should be_true
  end

  it "returns false when nonregistered plugin name passed in" do
    @manager.plugin_exists?('acts_as_absent').should be_false
  end

  it "returns true when registered plugin directory passed in" do
    @manager.plugin_exists?(@plugin_root).should be_true
  end

  it "returns false when nonregistered plugin directory passed in" do
    @manager.plugin_exists?("#{RAILS_ROOT}/vendor/plugins/non_existent").should be_false
  end
end

describe ComponentManager, "#plugin_path" do
  it_should_behave_like "ComponentFu::ComponentManager"

  before do
    @plugin_root = "#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy"
    @manager.register_plugin @plugin_root
  end

  it "returns the path for the passed in plugin name" do
    @manager.plugin_path('acts_as_spiffy').should == File.expand_path(@plugin_root)
  end

  it "returns nil when plugin does not exist" do
    @manager.plugin_path('acts_as_absent').should be_nil
  end
end

describe ComponentManager, "#files_on_load_path" do
  it_should_behave_like "ComponentFu::ComponentManager"

  before do
    @acts_as_spiffy_path = File.expand_path("#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy")
    @manager.register_plugin @acts_as_spiffy_path
    @super_spiffy_path = File.expand_path("#{RAILS_ROOT}/vendor/plugins/super_spiffy")
    @manager.register_plugin @super_spiffy_path
  end
  
  it "returns the list of file paths that match the passed in value" do
    @manager.files_on_load_path("spiffy_helper").should == [
      "#{@acts_as_spiffy_path}/app/helpers/spiffy_helper.rb",
      "#{@super_spiffy_path}/app/helpers/spiffy_helper.rb",  
      File.expand_path("#{RAILS_ROOT}/app/helpers/spiffy_helper.rb"),
    ]
  end
end

describe ComponentManager, "#layout_paths" do
  it_should_behave_like "ComponentFu::ComponentManager"

  before do
    @acts_as_spiffy_path = File.expand_path("#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy")
    @manager.register_plugin @acts_as_spiffy_path
    @super_spiffy_path = File.expand_path("#{RAILS_ROOT}/vendor/plugins/super_spiffy")
    @manager.register_plugin @super_spiffy_path
  end

  it "returns the layout paths ordered by precedence" do
    @manager.layout_paths.should == [
      "#{@super_spiffy_path}/app/views/layouts",
      "#{@acts_as_spiffy_path}/app/views/layouts",
    ]
  end
end
end