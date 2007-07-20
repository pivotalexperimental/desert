module Dependencies
  def load_missing_constant_with_component_fu(from_mod, const_name)
    qualified_name = qualified_name_for from_mod, const_name
    path_suffix = qualified_name.underscore
    files = ComponentFu::ComponentManager.instance.files_on_load_path(path_suffix)

    qualified_name = qualified_name_for(from_mod, const_name)
    files.each do |file|
      load_file_if_not_load_once file, qualified_name
    end

    return from_mod.const_get(const_name) if from_mod.const_defined?(const_name)
    return nil
  end
  alias_method_chain :load_missing_constant, :component_fu

  def load_file_if_not_load_once(file, qualified_name)
    return if load_once_paths.any? do |load_once_path|
      File.dirname(file).include?(load_once_path)
    end
    
    load file
    unless autoloaded_constants.include?(qualified_name)
      autoloaded_constants << qualified_name
    end
  end
end