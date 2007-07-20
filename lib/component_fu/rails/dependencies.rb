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
      parent_mod = from_mod.parent
      if from_mod.parents.any? {|p| p.const_defined?(const_name)}
        raise "Constant #{from_mod}::#{const_name} Not found"
      end
      if parent_mod != from_mod
        return parent.const_missing(const_name)
      end
      from_mod.const_set(const_name, Module.new)
      unless autoloaded_constants.include?(qualified_name)
        autoloaded_constants << qualified_name
      end
    end
    from_mod.const_get(const_name)
  end
  alias_method_chain :load_missing_constant, :component_fu

  def add_to_autoloaded_constants(qualified_name, file)
    return if autoloaded_constants.include?(qualified_name)
    return if load_once_path?(file)
    autoloaded_constants << qualified_name
  end
end
#
#if (parent = from_mod.parent) && parent != from_mod &&
#    ! from_mod.parents.any? { |p| p.const_defined?(const_name) }
## If our parents do not have a constant named +const_name+ then we are free
## to attempt to load upwards. If they do have such a constant, then this
## const_missing must be due to from_mod::const_name, which should not
## return constants from from_mod's parents.
#begin
#  return parent.const_missing(const_name)
#rescue NameError => e
#  raise unless e.missing_name? qualified_name_for(parent, const_name)
#  raise name_error
#end
