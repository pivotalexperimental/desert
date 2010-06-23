ActiveRecord::ConnectionAdapters::SchemaStatements.module_eval do
  def initialize_schema_information_with_plugins
    initialize_schema_information_without_plugins

    unless Desert::PluginMigrations::Migrator.legacy_schema_table_exists?
      execute "CREATE TABLE #{Desert::PluginMigrations::Migrator.schema_info_table_name} (plugin_name #{type_to_sql(:string)}, version #{type_to_sql(:integer)})"
    end
  end
  alias_method_chain :initialize_schema_information, :plugins

  def dump_schema_information_with_plugins
    schema_information = []

    dump = dump_schema_information_without_plugins
    schema_information << dump if dump

    if Desert::PluginMigrations::Migrator.legacy_schema_table_exists?
      plugins = ActiveRecord::Base.connection.select_all("SELECT * FROM #{Desert::PluginMigrations::Migrator.schema_info_table_name}")
      plugins.each do |plugin|
        if (version = plugin['version'].to_i) > 0
          plugin_name = ActiveRecord::Base.quote_value(plugin['plugin_name'])
          schema_information << "INSERT INTO #{Desert::PluginMigrations::Migrator.schema_info_table_name} (plugin_name, version) VALUES (#{plugin_name}, #{version})"
        end
      end
    end

    schema_information.join(";\n")
  end
  alias_method_chain :dump_schema_information, :plugins
end
