module Rails
  class Initializer
    def load_plugin_with_component_fu(directory)
      ComponentFu::ComponentManager.components << directory
      load_plugin_without_component_fu(directory)
    end
    alias_method_chain :load_plugin, :component_fu
  end
end