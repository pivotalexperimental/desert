dir = File.dirname(__FILE__)
require "#{dir}/../rails_spec_helper"

describe Module, "#const_missing" do
  before do
    components = ComponentFu::ComponentManager.components
    components.should include("#{RAILS_ROOT}/vendor/plugins/acts_as_retarded")
  end

  it "loads component helpers" #do
#    Object.const_defined?(:RetardedHelper).should be_false
#    RetardedHelper.respond_to?(:duhh).should be_true
#  end
end