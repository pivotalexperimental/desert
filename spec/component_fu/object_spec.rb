require "spec/spec_helper"

describe Object, "#require" do
  before do
    @fixture = Object.new
    @manager = ComponentManager.new
    ComponentManager.instance = @manager
  end
  
  it "requires Compentized plugins"
end