require "spec/spec_helper"

module ActiveRecord
class Migration
describe ComponentFuMigration, "#migrate_plugin" do
  it_should_behave_like "ComponentFu::ComponentManager fixture"
end

describe ComponentFuMigration, "#schema_version_equivalent_to" do
end
end
end