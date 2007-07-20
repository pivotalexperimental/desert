require "spec/spec_helper"

module Rails
describe Initializer, :shared => true do
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

  it "adds the plugin to the components registry" do
    dir = "#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy"
    @initializer.load_plugin dir
    ComponentFu::ComponentManager.components.should include(dir)
  end
end

describe Initializer, "#componentize!" do
  it_should_behave_like "Rails::Initializer"

  it "adds the currently_loading_plugin to the components registry" do
    dir = "#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy"
    @initializer.currently_loading_plugin = dir
    ComponentFu::ComponentManager.components.should include(dir)
  end
end
end