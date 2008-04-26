dir = File.dirname(__FILE__)
if Desert::VersionChecker.rails_version_is_below_1990?
  require "#{dir}/rails/1.2.0/initializer"
else
  require "#{dir}/rails/2.0.0/plugin"
end
require "#{dir}/rails/dependencies"
require "#{dir}/rails/migration"

require "#{dir}/rails/route_set"
