module Dependencies
  def load_missing_constant_with_desert(from_mod, const_name)
    qualified_name = qualified_name_for from_mod, const_name
    path_suffix = qualified_name.underscore

    unless define_constant_from_file(from_mod, const_name, qualified_name, path_suffix)
      unless define_constant_from_directory(from_mod, const_name, qualified_name, path_suffix)
        if from_mod == Object
          raise NameError, "Constant #{qualified_name} from #{path_suffix}.rb not found"
        else
          begin
            return Object.const_missing(const_name)
          rescue NameError => e
            raise(
              NameError,
              "Constants #{qualified_name} from #{path_suffix}.rb and #{const_name} from #{const_name.to_s.underscore}.rb not found"
            )
          end
        end
      end
    end
    from_mod.const_get(const_name)
  end
  alias_method_chain :load_missing_constant, :desert

  def load_once_path?(path)
    load_once_paths.any? { |base| File.expand_path(path).starts_with? File.expand_path(base) }
  end

  def depend_on_with_desert(file_name, swallow_load_errors = false)
    Desert::Manager.files_on_load_path(file_name).each do |file|
      require_or_load(file)
    end
    require file_name
  rescue LoadError
    raise unless swallow_load_errors
  end
  alias_method_chain :depend_on, :desert

  protected
  def define_constant_from_file(from_mod, const_name, qualified_name, path_suffix)
    files = Desert::Manager.files_on_load_path(path_suffix)
    files.each do |file|
      load file
      next if autoloaded_constants.include?(qualified_name)
      next if load_once_path?(file)
      autoloaded_constants << qualified_name
    end
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