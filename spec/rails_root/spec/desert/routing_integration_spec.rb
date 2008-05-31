require File.expand_path("#{File.dirname(__FILE__)}/../rails_spec_helper")

module ActionController
  module Routing
    describe RouteSet do
      include ActionController::UrlWriter

      it "has plugin routes" do
        show_grand_poobah_path.should == "/poobahs/grand/show"
        acts_as_spiffy_path.should == "/spiffy/acts/as"
        super_spiffy_path.should == "/spiffy/super"
      end
    end
  end
end