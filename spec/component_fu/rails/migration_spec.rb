require "spec/spec_helper"

module ActiveRecord
class Migration
describe DesertMigration, "#migrate_plugin" do
  it_should_behave_like "Desert::ComponentManager fixture"
end

describe DesertMigration, "#schema_version_equivalent_to" do
end
end
end