require File.expand_path("#{File.dirname(__FILE__)}/../rails_spec_helper")

describe Module, "#const_missing when constants are unloaded" do
  it_should_behave_like "Remove Project Constants"
  before do
    SpiffyHelper
    Object.const_defined?(:SpiffyHelper).should be_true
    dependencies.clear
    Object.const_defined?(:SpiffyHelper).should be_false
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