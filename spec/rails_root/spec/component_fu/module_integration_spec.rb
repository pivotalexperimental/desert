dir = File.dirname(__FILE__)
require "#{dir}/../rails_spec_helper"

describe Module, "#const_missing" do
  it_should_behave_like "Remove Project Constants"
  before do
    plugins = ComponentFu::ComponentManager.plugins
    ComponentFu::ComponentManager.plugin_exists?('acts_as_spiffy').should be_true
  end

  it "loads component app file" do
    Object.const_defined?(:SpiffyHelper).should be_false
    SpiffyHelper.methods.should include('duhh')
  end
end