class Rails::Plugin::Loader
  def require_plugin(plugin_name)
    initializer.configuration.plugin_locators.each do |locator|
      locator.new(initializer).each do |plugin_loader|
        return plugin_loader.load if plugin_loader.name == plugin_name.to_sym
      end
    end
    raise "Plugin '#{plugin_name}' does not exist"
  end

  protected
  def load_with_desert
    return if Desert::Manager.plugin_exists?(directory)
    plugin = Desert::Manager.register_plugin(directory) do
      load_without_desert
    end
    # TODO: Can we use Initializer::Configuration#default_load_paths to do this?
    initializer.configuration.controller_paths << plugin.controllers_path
  end
  alias_method_chain :load, :desert
end
