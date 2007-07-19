module ComponentFu
describe ComponentManager, " fixture", :shared => true do
  before do
    @original_manager = ComponentManager.instance
    @manager = ComponentManager.new
    ComponentManager.instance = @manager
  end

  after do
    ComponentManager.instance = @original_manager
  end
end
end