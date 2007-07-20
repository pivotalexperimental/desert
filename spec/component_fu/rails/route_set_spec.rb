require "spec/spec_helper"

module ActionController
module Routing
class RouteSet
  describe Mapper, "#routes_from_plugin" do
    it_should_behave_like "ComponentFu::ComponentManager fixture"

    before do
      @manager.plugins << "#{RAILS_ROOT}/vendor/plugins/the_grand_poobah"
    end

    it "adds a named route from the plugin" do
      map = ActionController::Routing::RouteSet::Mapper.new(nil)
      mock(map).named_route(
        "show_poobah",
        {:controller => "grand_poobah", :action => "show"}
      )
      map.routes_from_plugin('the_grand_poobah')
    end
  end
end
end
end