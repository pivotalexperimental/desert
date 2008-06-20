require File.expand_path("#{File.dirname(__FILE__)}/../../spec_helper")

describe 'Dependencies', "#load_missing_constant", :shared => true do
  it "loads the project" do
    SpiffyHelper.loaded_project?.should be_true
  end

  it "adds constant to autoloaded_constants" do
    SpiffyHelper
    Spiffy::SpiffyController
    expected_constant_order = [
      "SpiffyHelper",
      "Spiffy",
      "ApplicationHelper",
      "ApplicationController",
      "Spiffy::SpiffyController",
    ]

    constants_to_check = dependencies.autoloaded_constants
    constants_to_check.delete_if do |name|
      !expected_constant_order.include?(name)
    end
    constants_to_check.should == expected_constant_order
  end

  it "does not add constants on the load_once_paths to autoloaded_constants" do
    @manager.register_plugin "#{RAILS_ROOT}/vendor/plugins/load_me_once"
    LoadMeOnce
    dependencies.autoloaded_constants.should_not include("LoadMeOnce")
  end

  it "returns module defined in parent module" do
    fixture = Object.new
    fixture.extend Spiffy::Something
    fixture.unspiffy.should == Spiffy::UnspiffyController
  end

  it "raises error when constant file cannot be loaded from Object" do
    lambda do
      NoModuleExists
    end.should raise_error(
      NameError,
      "Constant NoModuleExists from no_module_exists.rb not found"
    )
  end

  it "raises error when constant is chained and there is no file" do
    lambda do
      Spiffy::NoModuleExists
    end.should raise_error(
      NameError,
      "Constant Spiffy::NoModuleExists from spiffy/no_module_exists.rb not found\n" <<
      "Constant NoModuleExists from no_module_exists.rb not found"
    )
  end
end

describe 'Dependencies', " with one plugin", :shared => true do
  before do
    dependencies.load_paths.clear
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

  it "loads constants from Object when referenced in an anonymous classes" do
    class << Object.new
      ActsAsSpiffyFile.class.should == Class
    end
  end
end

describe 'Dependencies', " with two plugins", :shared => true do
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
    load_me_once_path = "#{RAILS_ROOT}/vendor/plugins/load_me_once"
    dependencies.load_once_paths.should include(load_me_once_path)
    @manager.register_plugin load_me_once_path
    LoadMeOnce
    dependencies.autoloaded_constants.should_not include("LoadMeOnce")
  end

  it "loads constants from Object when referenced in a module" do
    module SpiffyHelper
      ActsAsSpiffyFile.class.should == Class
    end
  end

  it "loads constants from Object when referenced in an anonymous classes" do
    class << Object.new
      ActsAsSpiffyFile.class.should == Class
    end
  end
end

describe "Dependencies" do
  it_should_behave_like "Desert::Manager fixture"

  before do
    @original_load_paths = dependencies.load_paths
    @original_load_once_paths = dependencies.load_once_paths.dup
    dependencies.load_once_paths << "#{RAILS_ROOT}/vendor/plugins/load_me_once"
  end

  after do
    Object.send(:remove_const, :NotInApp) if Object.const_defined?(:NotInApp)
    dependencies.load_paths.clear
    dependencies.load_paths.concat(@original_load_paths)
    dependencies.load_once_paths.clear
    dependencies.load_once_paths.concat(@original_load_once_paths)
  end
  
  describe "#load_missing_constant with one plugin" do
    it_should_behave_like "Dependencies#load_missing_constant"
    it_should_behave_like "Dependencies with one plugin"

    before do
      dependencies.load_missing_constant(Object, :SpiffyHelper)
    end
  end

  describe "#depend_on with one plugin" do
    it_should_behave_like "Dependencies with one plugin"

    before do
      dependencies.depend_on "spiffy_helper"
      Object.should be_const_defined(:SpiffyHelper)
      dir = File.dirname(__FILE__)
      $LOAD_PATH.unshift("#{dir}/../../external_files")
    end

    it "loads file using ruby mechanism when file is not in plugin" do
      require_dependency 'not_in_app'
      NotInApp.should be_loaded
    end

    it "does not load file when it exists in the plugin" do
      require_dependency 'spiffy_helper'
      SpiffyHelper.methods.should_not include('external_file_loaded?')
    end
  end

  describe "#depend_on with two plugins" do
    it_should_behave_like "Dependencies with two plugins"

    before do
      dependencies.depend_on "spiffy_helper"
      Object.should be_const_defined(:SpiffyHelper)
    end
  end

  describe "#load_missing_constant" do
    context "with two plugins" do
      it_should_behave_like "Dependencies#load_missing_constant"
      it_should_behave_like "Dependencies with two plugins"

      before do
        dependencies.load_missing_constant(Object, :SpiffyHelper)
      end
    end

    context "when referencing a file defined outside of the standard Rails directory structure" do
      context "when the referenced constant is defined in Object" do
        before do
          external_file_path = File.expand_path("#{File.dirname(__FILE__)}/../../external_files")
          File.exists?(File.join(external_file_path, "not_in_app.rb")).should be_true
          dependencies.load_paths << external_file_path
        end

        it "when the referenced constant is defined within the file, returns that constant" do
          NotInApp.should be_loaded
        end

        it "when the referenced constant is not defined within the file, raises an error" do
          lambda { FileWithoutModule }.should raise_error(
            NameError,
            "Constant FileWithoutModule from file_without_module.rb not found"
          )
        end
      end

      context "when the referenced constant is defined in a module OTHER than Object" do
        before do
          dir = File.dirname(__FILE__)
          dependencies.load_paths << "#{dir}/../../external_files"
        end

        it "when the referenced constant is defined within the file, returns that constant" do
          ParentModuleNotInApp::ChildModuleNotInApp.should be_loaded
        end

        it "when the referenced constant is not defined within the file, raises an error" do
          lambda { ParentModuleNotInApp::ChildFileWithoutModule }.should raise_error(
            NameError,
            "Constant ParentModuleNotInApp::ChildFileWithoutModule from parent_module_not_in_app/child_file_without_module.rb not found\n" +
            "Constant ChildFileWithoutModule from child_file_without_module.rb not found"
          )
        end
      end
    end
  end
end
