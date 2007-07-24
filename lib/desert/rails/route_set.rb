module Desert
  module Rails
    module RouteSet
      # Loads the set of routes from within a plugin and evaluates them at this
      # point within an application's main <tt>routes.rb</tt> file.
      #
      # Plugin routes are loaded from <tt><plugin_root>/routes.rb</tt>.
      def routes_from_plugin(name)
        name = name.to_s
        routes_path = File.join(
          Desert::Manager.plugin_path(name),
          "config/routes.rb"
        )
        RAILS_DEFAULT_LOGGER.debug "Loading routes from #{routes_path}."
        eval(IO.read(routes_path), binding, routes_path) if File.file?(routes_path)
      end
    end
  end
end

class ActionController::Routing::RouteSet::Mapper
  include Desert::Rails::RouteSet
end