dir = File.dirname(__FILE__)

dir = File.dirname(__FILE__)
require "#{dir}/plugin_migrations/migrator"
if ActiveRecord::ConnectionAdapters::SchemaStatements.instance_methods.include?('initialize_schema_information')
  require "#{dir}/plugin_migrations/1.2/migrator"
  require "#{dir}/plugin_migrations/1.2/extensions/schema_statements"
else
  require "#{dir}/plugin_migrations/2.1/migrator"
  require "#{dir}/plugin_migrations/2.1/extensions/schema_statements"
end
