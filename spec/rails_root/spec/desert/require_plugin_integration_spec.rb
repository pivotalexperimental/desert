require File.expand_path("#{File.dirname(__FILE__)}/../rails_spec_helper")

module Rails
  describe Initializer, "#require_plugin" do
    it "loads the required plugin before finishing the current plugin" do
      Desert::Manager.plugins.should == [
      Desert::Manager.find_plugin('the_grand_poobah'),
      Desert::Manager.find_plugin('acts_as_spiffy'),
      Desert::Manager.find_plugin('aa_depends_on_acts_as_spiffy'),
      Desert::Manager.find_plugin('load_me_once'),
      Desert::Manager.find_plugin('super_spiffy'),
      ]
    end
  end
end