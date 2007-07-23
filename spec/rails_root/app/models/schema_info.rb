class SchemaInfo < ActiveRecord::Base
  set_table_name ActiveRecord::Migrator.schema_info_table_name
end