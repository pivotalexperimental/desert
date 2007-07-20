dir = File.dirname(__FILE__)
require "#{dir}/../rails_spec_helper"

module Rails
describe Initializer, "#require_plugin" do
  it "loads the required plugin before finishing the current plugin" do
    ComponentFu::ComponentManager.plugins.should == [
      "#{RAILS_ROOT}/vendor/plugins/the_grand_poobah",
      "#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy",
      "#{RAILS_ROOT}/vendor/plugins/aa_depends_on_acts_as_spiffy",
      "#{RAILS_ROOT}/vendor/plugins/load_me_once",
      "#{RAILS_ROOT}/vendor/plugins/super_spiffy",
    ]
  end
end
end