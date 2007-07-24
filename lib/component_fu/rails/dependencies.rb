module Dependencies
  def load_missing_constant_with_component_fu(from_mod, const_name)
    qualified_name = qualified_name_for from_mod, const_name

    define_constant_from_file from_mod, const_name, qualified_name
    unless from_mod.const_defined?(const_name)
      define_constant_from_directory from_mod, const_name, qualified_name
    end
    from_mod.const_get(const_name)
  end
  alias_method_chain :load_missing_constant, :component_fu

  def load_once_path?(path)
    load_once_paths.any? { |base| File.expand_path(path).starts_with? File.expand_path(base) }
  end

  def depend_on_with_component_fu(file_name, swallow_load_errors = false)
    ComponentFu::ComponentManager.files_on_load_path(file_name).each do |file|
      require_or_load(file)
    end
    require file_name
  rescue LoadError
    raise unless swallow_load_errors
  end
  alias_method_chain :depend_on, :component_fu

  protected
  def define_constant_from_file(from_mod, const_name, qualified_name)
    path_suffix = qualified_name.underscore
    files = ComponentFu::ComponentManager.files_on_load_path(path_suffix)
    files.each do |file|
      load file
      next if autoloaded_constants.include?(qualified_name)
      next if load_once_path?(file)
      autoloaded_constants << qualified_name
    end
  end

  def define_constant_from_directory(from_mod, const_name, qualified_name)
    path_suffix = qualified_name.underscore

    unless ComponentFu::ComponentManager.directory_on_load_path?(path_suffix)
      raise NameError, "Constant #{qualified_name} not found"
    end

    from_mod.const_set(const_name, Module.new)
    unless autoloaded_constants.include?(qualified_name)
      autoloaded_constants << qualified_name
    end
  end
end