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
    results = []
    execute("select * from plugin_schema_info;").each_hash do |hash|
      results << hash
    end
    results.should == [
      {
        'plugin_name' => 'acts_as_spiffy',
        'version' => '2'
      },
    ]
  end

  it "raises error when invalid plugin name passed in" do
    proc do
      Migration.migrate_plugin('acts_as_absent', 2)
    end.should raise_error(ArgumentError, "No plugin found named acts_as_absent")
  end

  def drop_tables
    execute("show tables").each_hash do |hash|
      table_name = hash.values.first
      execute "drop table `#{table_name}`"
    end
  end

  def execute(sql)
    Base.connection.execute sql
  end
end
end
