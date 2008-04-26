dir = File.dirname(__FILE__)
if ActiveRecord::ConnectionAdapters::SchemaStatements.instance_methods.include?('initialize_schema_information')
  require "#{dir}/1.0/schema_statements"
else
  require "#{dir}/2.1/schema_statements"
end