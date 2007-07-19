module Rails
  class Initializer
    attr_accessor :currently_loading_plugin

    def componentize!
      ComponentFu::ComponentManager.components << @currently_loading_plugin
    end

    alias_method :load_plugin_without_component_fu, :load_plugin
    def load_plugin_with_component_fu(directory)
      @currently_loading_plugin = directory
      begin
        load_plugin_without_component_fu(directory)
      ensure
        @currently_loading_plugin = nil
      end
    end
    alias_method :load_plugin, :load_plugin_with_component_fu
  end
end