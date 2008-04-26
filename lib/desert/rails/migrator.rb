dir = File.dirname(__FILE__)

if ActiveRecord::Migrator.private_instance_methods.include?('migration_classes')
  require "#{dir}/1.2.0/migrator"
else
  require "#{dir}/2.1/migrator"
end