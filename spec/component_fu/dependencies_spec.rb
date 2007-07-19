require "spec/spec_helper"

describe Dependencies, "#load_missing_constant", :shared => true do
  it_should_behave_like "ComponentFu::ComponentManager fixture"

  before do
    @dependencies = Object.new
    @dependencies.extend Dependencies
    @fixture = Object.new
  end

  it "loads the project" do
    @fixture.loaded_project?.should be_true
  end
  
  it "adds constant to autoloaded_constants" do
    @dependencies.autoloaded_constants.should == [ "SpiffyHelper" ]
  end
end

describe Dependencies, "#load_missing_constant with one plugin" do
  it_should_behave_like "Dependencies#load_missing_constant"

  before do
    @manager.components << "#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy"
    @dependencies.load_missing_constant(Object, :SpiffyHelper)
    @fixture.extend SpiffyHelper
  end

  it "loads the plugin" do
    @fixture.loaded_acts_as_spiffy?.should be_true
  end

  it "lets the project override method from plugin" do
    @fixture.duhh.should == "duhh from project"
  end

  it "lets method defined in plugin stick around" do
    @fixture.im_spiffy.should == "im_spiffy from acts_as_spiffy"
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

  it "loads the both plugins" do
    @fixture.loaded_acts_as_spiffy?.should be_true
    @fixture.loaded_super_spiffy?.should be_true
  end

  it "lets the project override methods from both plugins" do
    @fixture.duhh.should == "duhh from project"
  end

  it "lets the later plugin override methods" do
    @fixture.im_spiffy.should == "im_spiffy from super_spiffy"
  end
end