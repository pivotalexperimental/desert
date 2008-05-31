ActiveRecord::ConnectionAdapters::SchemaStatements.module_eval do
  def initialize_schema_migrations_table_with_plugins
    initialize_schema_migrations_table_without_plugins

    begin
      execute "CREATE TABLE #{Desert::PluginMigrations::Migrator.schema_info_table_name} (plugin_name #{type_to_sql(:string)}, version #{type_to_sql(:integer)})"
    rescue ActiveRecord::StatementInvalid
      # Schema has been initialized
    end
  end
  alias_method_chain :initialize_schema_migrations_table, :plugins
end