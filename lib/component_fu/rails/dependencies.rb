module Dependencies
  def load_missing_constant_with_component_fu(from_mod, const_name)
    qualified_name = qualified_name_for from_mod, const_name
    path_suffix = qualified_name.underscore
    load path_suffix

    qualified_name = qualified_name_for(from_mod, const_name)
    unless autoloaded_constants.include?(qualified_name)
      autoloaded_constants << qualified_name
    end
    from_mod.const_get(const_name)
  end
  alias_method_chain :load_missing_constant, :component_fu
end