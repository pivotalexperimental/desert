require File.expand_path("#{File.dirname(__FILE__)}/../rails_spec_helper")

module ActionController
  describe "Routing from plugins" do
    include ActionController::UrlWriter

    it "includes controllers only defined in another plugin" do
      Routing.possible_controllers.should include("super_spiffy")
    end
  end
end