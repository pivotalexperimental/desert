require "active_support"
require "action_controller"
require "active_record"
require "action_mailer"

require "desert/plugin"
require "desert/component_manager"
require "desert/rails/initializer"
require "desert/rails/dependencies"
require "desert/rails/migration"
require "desert/ruby/object"
require "desert/ruby/class"

require "desert/rails/route_set"

require "desert/plugin_migrations/migrator"
require "desert/plugin_migrations/extensions/schema_statements"

require "desert/plugin_templates/action_controller"
require "desert/plugin_templates/action_mailer"
require "desert/plugin_templates/action_view"