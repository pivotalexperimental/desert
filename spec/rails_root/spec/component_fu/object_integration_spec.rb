dir = File.dirname(__FILE__)
require "#{dir}/../rails_spec_helper"

describe Object, "#require" do
  it_should_behave_like "Remove Project Constants"

  it "requires the helper" do
    require 'retarded_helper'
    Object.const_defined?(:RetardedHelper).should be_true
  end
end

describe Object, "#load" do
  it_should_behave_like "Remove Project Constants"

  it "loads the helper" do
    load 'retarded_helper'
    Object.const_defined?(:RetardedHelper).should be_true
  end
end