dir = File.dirname(__FILE__)
require "#{dir}/../rails_spec_helper"

describe Object, "#require" do
  before do
    if Object.const_defined?(:RetardedHelper)
      Object.send(:remove_const, :RetardedHelper)
    end
  end

  it "requires the helper" do
    require 'retarded_helper'
    Object.const_defined?(:RetardedHelper).should be_true
  end
end

describe Object, "#load" do
  before do
    if Object.const_defined?(:RetardedHelper)
      Object.send(:remove_const, :RetardedHelper)
    end
  end

  it "loads the helper" do
    load 'retarded_helper'
    Object.const_defined?(:RetardedHelper).should be_true
  end
end