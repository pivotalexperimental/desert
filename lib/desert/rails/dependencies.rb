dependencies = ActiveSupport.const_defined?(:Dependencies) ? ActiveSupport::Dependencies : Dependencies
dependencies.module_eval do
  def load_missing_constant_with_desert(from_mod, const_name)
    from_mod = guard_against_anonymous_module(from_mod)
    qualified_name = qualified_name_for from_mod, const_name
    path_suffix = qualified_name.underscore

    if define_constant_with_desert_loading(from_mod, const_name, qualified_name, path_suffix)
      return from_mod.const_get(const_name)
    end

    if has_parent_module?(from_mod)
      look_for_constant_in_parent_module(from_mod, const_name, qualified_name, path_suffix)
    else
      raise NameError, "Constant #{qualified_name} from #{path_suffix}.rb not found"
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
  def define_constant_with_desert_loading(from_mod, const_name, qualified_name, path_suffix)
    define_constant_from_file(from_mod, const_name, qualified_name, path_suffix) ||
      define_constant_from_directory(from_mod, const_name, qualified_name, path_suffix)
  end

  def has_parent_module?(mod)
    mod != Object
  end

  def look_for_constant_in_parent_module(from_mod, const_name, qualified_name, path_suffix)
    return from_mod.parent.const_missing(const_name)
  rescue NameError => e
    raise NameError, "Constant #{qualified_name} from #{path_suffix}.rb not found\n#{e.message}"
  end

  def guard_against_anonymous_module(from_mod)
    return Object if from_mod.name.blank?
    return from_mod
  end

  def define_constant_from_file(from_mod, const_name, qualified_name, path_suffix)
    files = Desert::Manager.files_on_load_path(path_suffix)
    files.each do |file|
      require_or_load file
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

    if autoloaded_constants.include?(qualified_name)
      raise "Constant #{qualified_name} is already autoloaded but is not defined as a constant"
    end
    from_mod.const_set(const_name, Module.new)
    autoloaded_constants << qualified_name
    return true
  end
end
