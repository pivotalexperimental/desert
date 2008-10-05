require File.expand_path("#{File.dirname(__FILE__)}/../../spec_helper")

module ActionController
  module Routing
    class RouteSet
      describe Mapper do
        describe "#routes_from_plugin" do
          it_should_behave_like "Desert::Manager fixture"

          before do
            @manager.register_plugin "#{RAILS_ROOT}/vendor/plugins/the_grand_poobah"
          end

          it "adds a named route from the plugin" do
            map = ActionController::Routing::RouteSet::Mapper.new(nil)
            mock(map).named_route(
            "show_grand_poobah",
            "/poobahs/grand/show",
            {:controller => "grand_poobah", :action => "show"}
            )
            map.routes_from_plugin('the_grand_poobah')
          end
        end
      end
    end
  end
end