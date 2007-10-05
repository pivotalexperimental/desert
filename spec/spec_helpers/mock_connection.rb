describe "mock connection", :shared => true do
  before do
    @mock_connection = "connection"
    stub(ActiveRecord::Base).connection { @mock_connection }
    stub(@mock_connection).initialize_schema_information.returns(1)
    stub(@mock_connection).supports_migrations?.returns(true)
  end
end