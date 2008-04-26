describe "mock connection", :shared => true do
  before do
    @mock_connection = "connection"
    stub(ActiveRecord::Base).connection { @mock_connection }
    if ActiveRecord::ConnectionAdapters::SchemaStatements.instance_methods.include?('initialize_schema_information')
      stub(@mock_connection).initialize_schema_information.returns(1)
    else
      stub(@mock_connection).initialize_schema_migrations_table.returns(1)
    end
    stub(@mock_connection).supports_migrations?.returns(true)
  end
end