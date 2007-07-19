require "spec/spec_helper"

describe Object, "#require" do
  it_should_behave_like "ComponentFu::ComponentManager fixture"
  
  before do
    @fixture = Object.new
  end
  
  it "requires Compentized plugins" do
    plugin_root = "#{RAILS_ROOT}/vendor/plugins/acts_as_retarded"
    @manager.components << plugin_root

    @fixture.require 'retarded_helper'

    Object.const_defined?(:RetardedHelper).should == true
  end
end