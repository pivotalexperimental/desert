ActiveRecord::ConnectionAdapters::SchemaStatements.module_eval do
  def initialize_schema_migrations_table_with_plugins
    initialize_schema_migrations_table_without_plugins

    begin
      execute "CREATE TABLE #{Desert::PluginMigrations::Migrator.schema_migrations_table_name} (plugin_name #{type_to_sql(:string)}, version #{type_to_sql(:string)})"
#      plugins_and_versions = select_all("SELECT plugin_name, version from #{Desert::PluginMigrations::Migrator.schema_info_table_name}")
#      plugins_and_versions.each do |plugin, version|
#        execute "INSERT INTO #{Desert::PluginMigrations::Migrator.schema_migrations_table_name}"
#      end
    rescue ActiveRecord::StatementInvalid
      # Schema has been initialized
    end
  end
  alias_method_chain :initialize_schema_migrations_table, :plugins
end