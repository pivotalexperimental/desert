require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

describe Object, :shared => true do
  it_should_behave_like "Desert::Manager fixture"

  before do
    Object.const_defined?(:SpiffyHelper).should == false
    @fixture = Object.new
  end

  it "loads Compentized plugins" do
    Object.const_defined?(:SpiffyHelper).should == true
  end
end

describe Object, " one plugin", :shared => true do
  it_should_behave_like "Object"

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
end

describe Object, " two plugins", :shared => true do
  it_should_behave_like "Object"

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
end

describe Object, "#require" do
  it_should_behave_like "Desert::Manager fixture"

  before do
    dependencies.load_paths.clear
  end
  
  it "loads the project" do
    require 'not_in_app'
    NotInApp.should be_loaded
  end

  it "when given full path, loads external files" do
    require 'spec/external_files/spiffy_helper'
    SpiffyHelper.external_file_loaded?.should be_true
  end

  it "when relative path already on required files collection, does not load files" do
    Object.const_defined?(:SpiffyHelper).should be_false
    require "spiffy_helper"
    class << SpiffyHelper
      remove_method :duhh
    end
    $".include?("spiffy_helper.rb").should be_true

    require "spiffy_helper"
    SpiffyHelper.methods.should_not include('duhh')
  end

  it "when file contained in app, does not load file match not in app" do
    require "spiffy_helper"
    SpiffyHelper.duhh.should == "duhh from project"
    SpiffyHelper.respond_to?(:external_file_loaded?).should be_false
  end

  it "when file contained in app and requiring for the first time, returns true" do
    require("spiffy_helper").should be_true
  end
end

describe Object, "#require with one plugin" do
  it_should_behave_like "Object one plugin"

  before do
    require 'spiffy_helper'
  end
end

describe Object, "#require with two plugins" do
  it_should_behave_like "Object two plugins"

  before do
    require 'spiffy_helper'
  end

  it "requires the files that the constant points to" do
    SpiffyHelper.loaded_acts_as_spiffy?.should be_true
    SpiffyHelper.loaded_super_spiffy?.should be_true
    SpiffyHelper.duhh.should == "duhh from project"
    SpiffyHelper.im_spiffy.should == "im_spiffy from super_spiffy"
  end
end

describe Object, "#load with one plugin" do
  it_should_behave_like "Object one plugin"

  before do
    load 'spiffy_helper'
  end
end

describe Object, "#load with two plugins" do
  it_should_behave_like "Object two plugins"

  before do
    load 'spiffy_helper'
  end
end