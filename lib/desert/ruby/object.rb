class Object
  def require_with_desert(path)
    relative_include_path = (path =~ /\.rb$/) ? path : "#{path}.rb"
    if $".include?(relative_include_path)
      return false
    else
      __each_matching_file(path) do |expanded_path|
        require_without_desert expanded_path
      end
      $" << relative_include_path
      return true
    end
  end
  alias_method_chain :require, :desert

  def load_with_desert(file)
    __each_matching_file(file) do |file|
      load_without_desert file
    end
  end
  alias_method_chain :load, :desert

  private
  def __each_matching_file(file)
    files = Desert::Manager.instance.files_on_load_path(file)
    desert_file_exists = files.empty? ? false : true
    files.each do |component_file|
      yield(component_file)
    end

    return true if desert_file_exists
    yield(file)
  end
end