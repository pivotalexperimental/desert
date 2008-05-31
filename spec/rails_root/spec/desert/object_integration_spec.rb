require File.expand_path("#{File.dirname(__FILE__)}/../rails_spec_helper")

describe Object, "#require" do
  it_should_behave_like "Remove Project Constants"

  it "requires the helper" do
    require 'spiffy_helper'
    Object.const_defined?(:SpiffyHelper).should be_true
  end
end

describe Object, "#load" do
  it_should_behave_like "Remove Project Constants"

  it "loads the helper" do
    load 'spiffy_helper'
    Object.const_defined?(:SpiffyHelper).should be_true
  end
end