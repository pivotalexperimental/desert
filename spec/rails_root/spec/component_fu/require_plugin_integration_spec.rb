dir = File.dirname(__FILE__)
require "#{dir}/../rails_spec_helper"

module Rails
describe Initializer, "#require_plugin" do
  it "loads the required plugin before finishing the current plugin" do
    ComponentFu::ComponentManager.plugins.should == [
      ComponentFu::ComponentManager.find_plugin('the_grand_poobah'),
      ComponentFu::ComponentManager.find_plugin('acts_as_spiffy'),
      ComponentFu::ComponentManager.find_plugin('aa_depends_on_acts_as_spiffy'),
      ComponentFu::ComponentManager.find_plugin('load_me_once'),
      ComponentFu::ComponentManager.find_plugin('super_spiffy'),
    ]
  end
end
end