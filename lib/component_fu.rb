require "active_support"
require "action_controller"
require "active_record"

require "component_fu/component_manager"
require "component_fu/rails/initializer"
require "component_fu/rails/dependencies"
require "component_fu/ruby/object"
require "component_fu/ruby/class"

require "component_fu/rails/route_set"

require "component_fu/plugin_migrations/plugin_migrations"
require "component_fu/plugin_migrations/migrator"
require "component_fu/plugin_migrations/extensions/plugin"
require "component_fu/plugin_migrations/extensions/schema_statements"