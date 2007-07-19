require "spec/spec_helper"

describe Dependencies, "#load_missing_constant" do
  it_should_behave_like "ComponentFu::ComponentManager fixture"

  before do
    @dependencies = Object.new
    @dependencies.extend Dependencies
    @fixture = Object.new

    plugin_root = "#{RAILS_ROOT}/vendor/plugins/acts_as_retarded"
    @manager.components << plugin_root
  end

  it "requires the files that the constant points to" do
    @dependencies.load_missing_constant(Object, :RetardedHelper)
    @fixture.extend RetardedHelper
    @fixture.duhh.should == "duhh from acts_as_retarded"
  end
end