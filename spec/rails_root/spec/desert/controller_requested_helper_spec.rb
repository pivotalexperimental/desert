require File.expand_path("#{File.dirname(__FILE__)}/../rails_spec_helper")

module Spiffy
  describe SpiffyController, " registers ControllerRequestedHelper as a helper" do
    it "loads the ControllerRequestedHelper" do
      module_names = SpiffyController.master_helper_module.included_modules.collect { |mod| mod.to_s }
      module_names.should include("ControllerRequestedHelper")
    end
  end
end
