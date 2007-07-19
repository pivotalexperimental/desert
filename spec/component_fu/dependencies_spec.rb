require "spec/spec_helper"

describe Dependencies, "#load_missing_constant", :shared => true do
  it_should_behave_like "ComponentFu::ComponentManager fixture"

  before do
    @dependencies = Object.new
    @dependencies.extend Dependencies
    @fixture = Object.new
  end  
end

describe Dependencies, "#load_missing_constant with one plugin" do
  it_should_behave_like "Dependencies#load_missing_constant"

  before do
    @manager.components << "#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy"
  end

  it "requires the files that the constant points to" do
    @dependencies.load_missing_constant(Object, :SpiffyHelper)
    @fixture.extend SpiffyHelper
    @fixture.loaded_acts_as_spiffy?.should be_true
    @fixture.duhh.should == "duhh from acts_as_spiffy"
  end
end

describe Dependencies, "#load_missing_constant with two plugins" do
  it_should_behave_like "Dependencies#load_missing_constant"

  before do
    @manager.components << "#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy"
    @manager.components << "#{RAILS_ROOT}/vendor/plugins/super_spiffy"
    @dependencies.load_missing_constant(Object, :SpiffyHelper)
    @fixture.extend SpiffyHelper
  end

  it "requires the files that the constant points to" do
    @fixture.loaded_acts_as_spiffy?.should be_true
    @fixture.loaded_super_spiffy?.should be_true
  end

  it "lets plugins loaded later overwrite methods" do
    @fixture.duhh.should == "duhh from super_spiffy"
  end
end

describe Dependencies, "#load_missing_constant with two plugins and project" do
  it_should_behave_like "Dependencies#load_missing_constant"

  before do
    @manager.components << "#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy"
    @manager.components << "#{RAILS_ROOT}/vendor/plugins/super_spiffy"
  end
end