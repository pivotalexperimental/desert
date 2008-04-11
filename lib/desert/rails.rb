dir = File.dirname(__FILE__)
if Desert::VersionChecker.rails_version_is_below_1990?
  require "#{dir}/rails/1.x/initializer"
else
  require "#{dir}/rails/2.x/plugin"
end
require "#{dir}/rails/dependencies"
require "#{dir}/rails/migration"
require "#{dir}/rails/migrator"
require "#{dir}/rails/route_set"
