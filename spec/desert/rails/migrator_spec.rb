require File.expand_path("#{File.dirname(__FILE__)}/../../spec_helper")

describe ActiveRecord::Migrator::DesertMigrator do
  it_should_behave_like "mock connection"

  before do
    @migrator = ActiveRecord::Migrator.new(:up, '/')
  end

  it "latest_version returns zero if migration_classes is empty" do
    stub(@migrator).migration_classes {[]}
    @migrator.latest_version.should == 0
  end

  it "latest_version returns the latest migration number if there are migrations" do
    stub(@migrator).migration_classes {[[1, "first migration"], [2, "second migration"]]}
    @migrator.latest_version.should == 2
  end
end
