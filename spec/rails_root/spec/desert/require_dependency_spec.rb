require File.expand_path("#{File.dirname(__FILE__)}/../rails_spec_helper")

describe 'Dependencies', ".require_dependency" do
  it_should_behave_like "Remove Project Constants"
  before do
    SpiffyHelper
  end

  it "does not double load a file already loaded from const_missing hook" do
    SpiffyHelper.times_loaded.should == 1
    require_dependency 'spiffy_helper'
    SpiffyHelper.times_loaded.should == 1
  end

  it "allows require_dependency to be called again" do
    require_dependency 'spiffy_helper'
    SpiffyHelper.times_loaded.should == 1
  end
end

describe 'Dependencies', ".require_dependency when constants are unloaded" do
  it_should_behave_like "Remove Project Constants"
  before do
    Object.const_defined?(:SpiffyHelper).should be_false
    SpiffyHelper
    Object.const_defined?(:SpiffyHelper).should be_true
    dependencies.clear
    Object.const_defined?(:SpiffyHelper).should be_false
  end

  it "loads the both plugins" do
    require_dependency 'spiffy_helper'
    Object.const_defined?(:SpiffyHelper).should be_true
    SpiffyHelper.loaded_acts_as_spiffy?.should be_true
    SpiffyHelper.loaded_super_spiffy?.should be_true
  end

  it "lets the project override methods from both plugins" do
    require_dependency 'spiffy_helper'
    Object.const_defined?(:SpiffyHelper).should == true
    SpiffyHelper.duhh.should == "duhh from project"
  end

  it "lets the later plugin override methods" do
    require_dependency 'spiffy_helper'
    Object.const_defined?(:SpiffyHelper).should == true
    SpiffyHelper.im_spiffy.should == "im_spiffy from super_spiffy"
  end
end