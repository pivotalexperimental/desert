dir = File.dirname(__FILE__)
require "#{dir}/../rails_spec_helper"

describe Module, "#const_missing" do
  it_should_behave_like "Remove Project Constants"
  before do
    components = ComponentFu::ComponentManager.components
    components.should include("#{RAILS_ROOT}/vendor/plugins/acts_as_retarded")
  end

  it "loads component app file" do
    Object.const_defined?(:RetardedHelper).should be_false
    RetardedHelper.instance_methods.should include('duhh')
  end
end