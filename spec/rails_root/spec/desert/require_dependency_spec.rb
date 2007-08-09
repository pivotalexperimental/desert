dir = File.dirname(__FILE__)
require "#{dir}/../rails_spec_helper"

describe Dependencies, ".require_dependency" do
  it_should_behave_like "Remove Project Constants"
  before do
    SpiffyHelper
  end

  it "does not double load a file already loaded from const_missing hook" do
    SpiffyHelper.times_loaded.should == 1
    require_dependency 'spiffy_helper'
    SpiffyHelper.times_loaded.should == 1
  end
end