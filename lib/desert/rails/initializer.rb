module Rails
  class Initializer
    def load_plugin_with_desert(directory)
      return if Desert::ComponentManager.plugin_exists?(directory)
      Desert::ComponentManager.register_plugin(directory) do
        load_plugin_without_desert(directory)
      end
    end
    alias_method_chain :load_plugin, :desert

    def require_plugin(plugin_name)
      find_plugins(configuration.plugin_paths).sort.each do |path|
        return load_plugin(path) if File.basename(path) == plugin_name
      end
      raise "Plugin '#{plugin_name}' does not exist"
    end
  end
end