require "spec/spec_helper"

describe Dependencies, "#load_missing_constant", :shared => true do
  it_should_behave_like "ComponentFu::ComponentManager fixture"

  before do
    Dependencies.load_once_paths << "#{RAILS_ROOT}/vendor/plugins/load_me_once"
  end

  it "loads the project" do
    SpiffyHelper.loaded_project?.should be_true
  end
  
  it "adds constant to autoloaded_constants" do
    Dependencies.autoloaded_constants.should == [ "SpiffyHelper" ]
  end

  it "does not add constants on the load_once_paths to autoloaded_constants" do
    @manager.plugins << "#{RAILS_ROOT}/vendor/plugins/load_me_once"
    LoadMeOnce
    Dependencies.autoloaded_constants.should_not include("LoadMeOnce")
  end
end

describe Dependencies, "#load_missing_constant with one plugin" do
  it_should_behave_like "Dependencies#load_missing_constant"

  before do
    @manager.plugins << "#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy"
    Dependencies.load_missing_constant(Object, :SpiffyHelper)
  end

  it "loads the plugin" do
    SpiffyHelper.loaded_acts_as_spiffy?.should be_true
  end

  it "lets the project override method from plugin" do
    SpiffyHelper.duhh.should == "duhh from project"
  end

  it "lets method defined in plugin stick around" do
    SpiffyHelper.im_spiffy.should == "im_spiffy from acts_as_spiffy"
  end
end

describe Dependencies, "#load_missing_constant with two plugins" do
  it_should_behave_like "Dependencies#load_missing_constant"

  before do
    @manager.plugins << "#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy"
    @manager.plugins << "#{RAILS_ROOT}/vendor/plugins/super_spiffy"
    Dependencies.load_missing_constant(Object, :SpiffyHelper)
  end

  it "loads the both plugins" do
    SpiffyHelper.loaded_acts_as_spiffy?.should be_true
    SpiffyHelper.loaded_super_spiffy?.should be_true
  end

  it "lets the project override methods from both plugins" do
    SpiffyHelper.duhh.should == "duhh from project"
  end

  it "lets the later plugin override methods" do
    SpiffyHelper.im_spiffy.should == "im_spiffy from super_spiffy"
  end
end