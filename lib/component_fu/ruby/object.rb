class Object
  def require_with_component_fu(file)
    __component_fu_get_file(file) do |file|
      require_without_component_fu file
    end
  end
  alias_method_chain :require, :component_fu

  def load_with_component_fu(file)
    __component_fu_get_file(file) do |file|
      load_without_component_fu file
    end
  end
  alias_method_chain :load, :component_fu

  private
  def __component_fu_get_file(file)
    files = ComponentFu::ComponentManager.instance.files_on_load_path(file)
    component_fu_file_exists = files.empty? ? false : true
    files.each do |component_file|
      yield(component_file)
    end

    return true if component_fu_file_exists
    yield(file) 
  end
end