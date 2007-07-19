dir = File.dirname(__FILE__)
require "#{dir}/../rails_spec_helper"

describe "ComponentFu plugins" do
  it "registers componentized plugins" do
    components = ComponentFu::ComponentManager.components
    components.should include("#{RAILS_ROOT}/vendor/plugins/acts_as_retarded")
    components.should include("#{RAILS_ROOT}/vendor/plugins/super_retarded")
  end

  it "does not register non-componentized plugins" do
    components = ComponentFu::ComponentManager.components
    components.should_not include("#{RAILS_ROOT}/vendor/plugins/not_componentized")
  end
end