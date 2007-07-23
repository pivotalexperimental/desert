dir = File.dirname(__FILE__)
require "#{dir}/../rails_spec_helper"

module ActiveRecord
describe Migration, "#migrate_plugin"do
  before do
    drop_tables
  end

  after do
    drop_tables
  end

  it "creates plugin schema info table" do
    Migration.migrate_plugin('acts_as_spiffy', 2)
    results = select("select * from plugin_schema_info;")
    results.should == [
      {
        'plugin_name' => 'acts_as_spiffy',
        'version' => '2'
      },
    ]
  end

  it "migrates the data" do
    Migration.migrate_plugin('acts_as_spiffy', 2)
    tables = select("show tables")
    table_names = tables.collect do |row|
      row.values.first
    end
    table_names.should == [
      "companies",
      "employees",
      "plugin_schema_info",
      "schema_info"
    ]
  end

  it "raises error when invalid plugin name passed in" do
    proc do
      Migration.migrate_plugin('acts_as_absent', 2)
    end.should raise_error(ArgumentError, "No plugin found named acts_as_absent")
  end

  def drop_tables
    tables = select("show tables")
    tables.each do |row|
      table_name = row.values.first
      execute "drop table `#{table_name}`"
    end
  end

  def select(sql)
    result_set = []
    stream = execute(sql)
    stream.each_hash do |hash|
      result_set << hash
    end
    result_set
  end

  def execute(sql)
    Base.connection.execute(sql)
  end
end
end
