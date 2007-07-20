dir = File.dirname(__FILE__)
require "#{dir}/../rails_spec_helper"

describe Module, "#const_missing" do
  it_should_behave_like "Remove Project Constants"
  before do
    components = ComponentFu::ComponentManager.components
    components.should include("#{RAILS_ROOT}/vendor/plugins/acts_as_spiffy")
  end

  it "loads component app file" do
    Object.const_defined?(:SpiffyHelper).should be_false
    SpiffyHelper.methods.should include('duhh')
  end
end