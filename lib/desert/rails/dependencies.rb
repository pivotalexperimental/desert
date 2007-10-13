module Dependencies
  def load_missing_constant_with_desert(from_mod, const_name)
    from_mod = guard_against_anonymous_module(from_mod)
    qualified_name = qualified_name_for from_mod, const_name
    path_suffix = qualified_name.underscore

    if define_constant_from_file(from_mod, const_name, qualified_name, path_suffix)
      return from_mod.const_get(const_name)
    end

    if define_constant_from_directory(from_mod, const_name, qualified_name, path_suffix)
      return from_mod.const_get(const_name)
    end

    if from_mod == Object
      begin
        require path_suffix
      rescue LoadError => e
        raise NameError, "Constant #{qualified_name} from #{path_suffix}.rb not found"
      end
    end
    
    begin
      return from_mod.parent.const_missing(const_name)
    rescue NameError => e
      raise(
        NameError,
        "Constant #{qualified_name} from #{path_suffix}.rb not found\n#{e.message}"
      )
    end
  end
  alias_method_chain :load_missing_constant, :desert

  def load_once_path?(path)
    load_once_paths.any? { |base| File.expand_path(path).starts_with? File.expand_path(base) }
  end

  def depend_on_with_desert(file_name, swallow_load_errors = false)
    successfully_loaded_in_plugin = false
    Desert::Manager.files_on_load_path(file_name).each do |file|
      require_or_load(file)
      successfully_loaded_in_plugin = true
    end
    begin
      unless successfully_loaded_in_plugin
        require_or_load file_name
        loaded << File.expand_path(file_name)
      end
    rescue LoadError
      if !swallow_load_errors && !successfully_loaded_in_plugin
        raise
      end
    end
  end
  alias_method_chain :depend_on, :desert

  protected
  def guard_against_anonymous_module(from_mod)
    return Object if from_mod.name.blank?
    return from_mod
  end

  def define_constant_from_file(from_mod, const_name, qualified_name, path_suffix)
    files = Desert::Manager.files_on_load_path(path_suffix)
    files.each do |file|
      # TODO: JLM/BT -- figure out why require_or_load does not work on Windows.
      #      require_or_load file
      load file
      loaded << file.gsub(/\.rb$/, '')
      next if autoloaded_constants.include?(qualified_name)
      next if load_once_path?(file)
      autoloaded_constants << qualified_name
    end
    loaded << File.expand_path(path_suffix)
    from_mod.const_defined?(const_name)
  end

  def define_constant_from_directory(from_mod, const_name, qualified_name, path_suffix)
    return false unless Desert::Manager.directory_on_load_path?(path_suffix)

    from_mod.const_set(const_name, Module.new)
    unless autoloaded_constants.include?(qualified_name)
      autoloaded_constants << qualified_name
    end
    return true
  end
end