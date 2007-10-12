require "active_support"
require "active_record"
require "action_controller"
require "action_mailer"

dir = File.dirname(__FILE__)
require "#{dir}/desert/plugin"
require "#{dir}/desert/manager"
require "#{dir}/desert/rails/initializer"
require "#{dir}/desert/rails/dependencies"
require "#{dir}/desert/rails/migration"
require "#{dir}/desert/rails/migrator"
require "#{dir}/desert/ruby/object"
require "#{dir}/desert/ruby/class"

require "#{dir}/desert/rails/route_set"

require "#{dir}/desert/plugin_migrations/migrator"
require "#{dir}/desert/plugin_migrations/extensions/schema_statements"

require "#{dir}/desert/plugin_templates/action_controller"
require "#{dir}/desert/plugin_templates/action_mailer"
require "#{dir}/desert/plugin_templates/action_view"