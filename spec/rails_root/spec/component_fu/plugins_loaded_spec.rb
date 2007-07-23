dir = File.dirname(__FILE__)
require "#{dir}/../rails_spec_helper"

describe "ComponentFu plugins" do
  it "registers all plugins" do
    ComponentFu::ComponentManager.plugin_exists?('acts_as_spiffy').should be_true
    ComponentFu::ComponentManager.plugin_exists?('super_spiffy').should be_true
  end
end