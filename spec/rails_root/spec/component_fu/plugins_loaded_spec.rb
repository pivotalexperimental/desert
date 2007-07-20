dir = File.dirname(__FILE__)
require "#{dir}/../rails_spec_helper"

describe "ComponentFu plugins" do
  it "registers all plugins" do
    components = ComponentFu::ComponentManager.components
    components.should include("#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy")
    components.should include("#{RAILS_ROOT}/vendor/plugins/super_spiffy")
  end
end