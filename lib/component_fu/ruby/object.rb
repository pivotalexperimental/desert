class Object
  def require(file)
    component_fu_file_exists = false
    ComponentFu::ComponentManager.load_paths.each do |path|
      full_path = File.join(path, File.basename(file))
      full_path_rb = "#{full_path}.rb"
      if File.exists?(full_path_rb)
        component_fu_file_exists = true
        super(full_path_rb)
      end
    end
    begin
      super
    rescue Exception => e
      raise(e) unless component_fu_file_exists
    end
  end
end