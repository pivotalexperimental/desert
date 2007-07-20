module Rails
  class Initializer
    def load_plugin_with_component_fu(directory)
      return if ComponentFu::ComponentManager.plugins.include?(directory)
      load_plugin_without_component_fu(directory)
      ComponentFu::ComponentManager.plugins << directory
    end
    alias_method_chain :load_plugin, :component_fu

    def require_plugin(plugin_name)
      find_plugins(configuration.plugin_paths).sort.each do |path|
        return load_plugin(path) if File.basename(path) == plugin_name
      end
      raise "Plugin '#{plugin_name}' does not exist"
    end
  end
end