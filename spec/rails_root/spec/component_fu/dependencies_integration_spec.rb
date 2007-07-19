dir = File.dirname(__FILE__)
require "#{dir}/../rails_spec_helper"

describe Module, "#const_missing when constants are unloaded" do
  it_should_behave_like "Remove Project Constants"
  before do
    SpiffyHelper
    Object.const_defined?(:SpiffyHelper).should be_true
    Dependencies.remove_unloadable_constants!
    Object.const_defined?(:SpiffyHelper).should be_false

    @fixture = Object.new
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