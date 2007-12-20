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
      map_route_from_plugin(m)

      m.directory "vendor/plugins/#{file_name}/db"
      m.directory "vendor/plugins/#{file_name}/db/migrate"
      m.template "plugin_migration.rb", "vendor/plugins/#{file_name}/db/migrate/001_init_#{file_name}_plugin.rb" 

      m.directory "vendor/plugins/#{file_name}/lib"

      m.directory "vendor/plugins/#{file_name}/spec"
      m.directory "vendor/plugins/#{file_name}/spec/controllers"
      m.directory "vendor/plugins/#{file_name}/spec/fixtures"
      m.directory "vendor/plugins/#{file_name}/spec/models"
      m.directory "vendor/plugins/#{file_name}/spec/views"
      m.file "spec_helper.rb", "vendor/plugins/#{file_name}/spec/spec_helper.rb" 

      m.file "empty_file", "vendor/plugins/#{file_name}/init.rb"
    end
  end

  def map_route_from_plugin(m)
    logger.route "adding map.routes_from_plugin(:#{file_name}) to top of routes.rb"
    sentinel = 'ActionController::Routing::Routes.draw do |map|'
    m.gsub_file 'config/routes.rb', /(#{Regexp.escape(sentinel)})/mi do |match|
      "#{match}\n    map.routes_from_plugin(:#{file_name})\n"
    end
  end
end
