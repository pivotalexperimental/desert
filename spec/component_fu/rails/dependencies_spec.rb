require "spec/spec_helper"

describe Dependencies, "#load_missing_constant", :shared => true do
  it_should_behave_like "Desert::Manager fixture"

  before do
    Dependencies.load_once_paths << "#{RAILS_ROOT}/vendor/plugins/load_me_once"
  end

  it "loads the project" do
    SpiffyHelper.loaded_project?.should be_true
  end
  
  it "adds constant to autoloaded_constants" do
    SpiffyHelper
    Spiffy::SpiffyController
    Dependencies.autoloaded_constants.should == [
      "SpiffyHelper",
      "Spiffy",
      "ApplicationController",
      "Spiffy::SpiffyController",
    ]
  end

  it "does not add constants on the load_once_paths to autoloaded_constants" do
    @manager.register_plugin "#{RAILS_ROOT}/vendor/plugins/load_me_once"
    LoadMeOnce
    Dependencies.autoloaded_constants.should_not include("LoadMeOnce")
  end

  it "raises error when constant is chained and there is no file" do
    proc do
      Spiffy::NoModuleExists
    end.should raise_error(NameError, "Constant NoModuleExists not found")
  end
end

describe Dependencies, " with one plugin", :shared => true do
  before do
    @manager.register_plugin "#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy"
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

  it "loads constants within a module" do
    Spiffy::SpiffyController.acts_as_spiffy_loaded?.should be_true
  end

  it "loads constants from Object when referenced in a module" do
    module SpiffyHelper
      ActsAsSpiffyFile.class.should == Class
    end
  end
end

describe Dependencies, "#load_missing_constant with one plugin" do
  it_should_behave_like "Dependencies#load_missing_constant"
  it_should_behave_like "Dependencies with one plugin"

  before do
    Dependencies.load_missing_constant(Object, :SpiffyHelper)
  end
end

describe Dependencies, "#depend_on with one plugin" do
  it_should_behave_like "Desert::Manager fixture"
  it_should_behave_like "Dependencies with one plugin"

  before do
    Dependencies.depend_on "spiffy_helper"
    Object.should be_const_defined(:SpiffyHelper)
  end
end

describe Dependencies, " with two plugins", :shared => true do
  before do
    @manager.register_plugin "#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy"
    @manager.register_plugin "#{RAILS_ROOT}/vendor/plugins/super_spiffy"
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

  it "does not add constants on the load_once_paths to autoloaded_constants" do
    @manager.register_plugin "#{RAILS_ROOT}/vendor/plugins/load_me_once"
    LoadMeOnce
    Dependencies.autoloaded_constants.should_not include("LoadMeOnce")
  end

  it "loads constants from Object when referenced in a module" do
    module SpiffyHelper
      ActsAsSpiffyFile.class.should == Class
    end
  end
end

describe Dependencies, "#load_missing_constant with two plugins" do
  it_should_behave_like "Dependencies#load_missing_constant"
  it_should_behave_like "Dependencies with two plugins"

  before do
    Dependencies.load_missing_constant(Object, :SpiffyHelper)
  end
end

describe Dependencies, "#depend_on with two plugins" do
  it_should_behave_like "Desert::Manager fixture"
  it_should_behave_like "Dependencies with two plugins"

  before do
    Dependencies.depend_on "spiffy_helper"
    Object.should be_const_defined(:SpiffyHelper)
  end
end