require "spec/spec_helper"

module Rails
describe Initializer, :shared => true do
  it_should_behave_like "ComponentFu::ComponentManager fixture"

  before do
    @configuration = Configuration.new
    @initializer = Rails::Initializer.new(@configuration)
    class << @initializer
      public :load_plugin
    end
  end
end

describe Initializer, "#load_plugin" do
  it_should_behave_like "Rails::Initializer"

  it "adds the plugin to the plugins registry" do
    dir = "#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy"
    @initializer.load_plugin dir
    ComponentFu::ComponentManager.plugins.should include(dir)
  end
end

describe Initializer, "#require_plugin" do
  it_should_behave_like "Rails::Initializer"

  it "raises error when passed a plugin that doesn't exist" do
    proc do
      @initializer.require_plugin "i_dont_exist"
    end.should raise_error(RuntimeError, "Plugin 'i_dont_exist' does not exist")
  end

  it "adds the plugin to the plugins registry" do
    @initializer.load_plugin "#{RAILS_ROOT}/vendor/plugins/aa_depends_on_acts_as_spiffy"
    ComponentFu::ComponentManager.plugins.should == [
      "#{RAILS_ROOT}/vendor/plugins/the_grand_poobah",
      "#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy",
      "#{RAILS_ROOT}/vendor/plugins/aa_depends_on_acts_as_spiffy",
    ]
  end

  it "does not add plugin twice" do
    @initializer.load_plugin "#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy"
    @initializer.load_plugin "#{RAILS_ROOT}/vendor/plugins/aa_depends_on_acts_as_spiffy"
    ComponentFu::ComponentManager.plugins.should == [
      "#{RAILS_ROOT}/vendor/plugins/the_grand_poobah",
      "#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy",
      "#{RAILS_ROOT}/vendor/plugins/aa_depends_on_acts_as_spiffy",
    ]
  end
end
end