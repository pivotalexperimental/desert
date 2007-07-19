class Object
  def require(file)
    __component_fu_get_file(file) do |file|
      super file
    end
  end

  def load(file)
    __component_fu_get_file(file) do |file|
      super file
    end
  end

  private
  def __component_fu_get_file(file)
    component_fu_file_exists = false
    ComponentFu::ComponentManager.load_paths.each do |path|
      full_path = File.join(path, File.basename(file))
      full_path_rb = "#{full_path}.rb"
      if File.exists?(full_path_rb)
        component_fu_file_exists = true
        yield(full_path_rb)
      end
    end
    begin
      yield(file)
    rescue Exception => e
      raise(e) unless component_fu_file_exists
    end
  end
end