require "active_support"
require "active_record"
require "action_controller"
require "action_mailer"

dir = File.dirname(__FILE__)
require "#{dir}/desert/plugin"
require "#{dir}/desert/manager"
if Rails.const_defined?(:Plugin)
  Desert::RAILS_VERSION = 2
  require "#{dir}/desert/rails/2.0/loader"
else
  Desert::RAILS_VERSION = 1
  require "#{dir}/desert/rails/1.x/initializer"
end
require "#{dir}/desert/rails/dependencies"
require "#{dir}/desert/rails/migration"
require "#{dir}/desert/rails/migrator"
require "#{dir}/desert/ruby/object"

require "#{dir}/desert/rails/route_set"

require "#{dir}/desert/plugin_migrations/migrator"
require "#{dir}/desert/plugin_migrations/extensions/schema_statements"

require "#{dir}/desert/plugin_templates/action_controller"
require "#{dir}/desert/plugin_templates/action_mailer"
require "#{dir}/desert/plugin_templates/action_view"