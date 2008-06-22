require 'rails_generator'
require 'rails_generator/commands'

class DesertPluginGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      m.directory "vendor/plugins/#{file_name}"

      m.directory "vendor/plugins/#{file_name}/app"
      m.directory "vendor/plugins/#{file_name}/app/controllers"
      m.directory "vendor/plugins/#{file_name}/app/helpers"
      m.directory "vendor/plugins/#{file_name}/app/models"
      m.directory "vendor/plugins/#{file_name}/app/views"

      m.directory "vendor/plugins/#{file_name}/config"
      m.template "routes.rb", "vendor/plugins/#{file_name}/config/routes.rb"
      m.map_route_from_plugin

      m.directory "vendor/plugins/#{file_name}/db"
      m.directory "vendor/plugins/#{file_name}/db/migrate"
      # m.template "plugin_migration.rb", "vendor/plugins/#{file_name}/db/migrate/001_init_#{file_name}_plugin.rb" 

      m.directory "vendor/plugins/#{file_name}/lib"

      m.directory "vendor/plugins/#{file_name}/spec"
      m.directory "vendor/plugins/#{file_name}/spec/controllers"
      m.directory "vendor/plugins/#{file_name}/spec/fixtures"
      m.directory "vendor/plugins/#{file_name}/spec/models"
      m.directory "vendor/plugins/#{file_name}/spec/views"
      m.file "spec_helper.rb", "vendor/plugins/#{file_name}/spec/spec_helper.rb" 

      m.directory "vendor/plugins/#{file_name}/tasks"

      m.file "empty_file", "vendor/plugins/#{file_name}/init.rb"
    end
  end

end

module Desert #:nodoc:
  module Generator #:nodoc:
    module Commands #:nodoc:

      module Create
        def map_route_from_plugin
          logger.route "adding map.routes_from_plugin(:#{file_name}) to top of routes.rb"
          sentinel = 'ActionController::Routing::Routes.draw do |map|'
          gsub_file('config/routes.rb', /(#{Regexp.escape(sentinel)})/mi) do |match|
            "#{match}\n  map.routes_from_plugin(:#{file_name})\n"
          end
        end
      end

      module Destroy
        def map_route_from_plugin
          look_for = "\n  map.routes_from_plugin(:#{file_name})\n"
          logger.route "removing map.routes_from_plugin(:#{file_name}) from routes.rb"
          gsub_file 'config/routes.rb', /(#{Regexp.escape(look_for)})/mi, ''
        end
      end

      module List
        def map_route_from_plugin
          logger.route "adding map.routes_from_plugin(:#{file_name}) to top of routes.rb"
        end
      end
    end
  end
end

Rails::Generator::Commands::Create.send   :include,  Desert::Generator::Commands::Create
Rails::Generator::Commands::Destroy.send  :include,  Desert::Generator::Commands::Destroy
Rails::Generator::Commands::List.send     :include,  Desert::Generator::Commands::List