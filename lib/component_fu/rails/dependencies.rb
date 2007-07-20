module Dependencies
  def load_missing_constant_with_component_fu(from_mod, const_name)
    qualified_name = qualified_name_for from_mod, const_name
    path_suffix = qualified_name.underscore
    files = ComponentFu::ComponentManager.instance.files_on_load_path(path_suffix)

    qualified_name = qualified_name_for(from_mod, const_name)
    files.each do |file|
      load file
      add_to_autoloaded_constants qualified_name, file
    end

    unless from_mod.const_defined?(const_name)
      define_missing_constant from_mod, const_name, qualified_name
    end
    from_mod.const_get(const_name)
  end
  alias_method_chain :load_missing_constant, :component_fu

  def add_to_autoloaded_constants(qualified_name, file)
    return if autoloaded_constants.include?(qualified_name)
    return if load_once_path?(file)
    autoloaded_constants << qualified_name
  end

  def define_missing_constant(from_mod, const_name, qualified_name)
    parent_mod = from_mod.parent
    if parent_mod != from_mod
      return parent_mod.const_missing(const_name)
    end
    from_mod.const_set(const_name, Module.new)
    unless autoloaded_constants.include?(qualified_name)
      autoloaded_constants << qualified_name
    end
  end
end