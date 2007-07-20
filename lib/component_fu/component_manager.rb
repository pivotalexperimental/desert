module ComponentFu
  class ComponentManager
    class << self
      def instance
        @instance ||= new
      end
      attr_writer :instance

      protected
      def method_missing(method_name, *args, &block)
        instance.__send__(method_name, *args, &block)
      end
    end

    attr_reader :components, :loading_plugin
    
    def initialize
      @components = []
    end

    def load_paths
      paths = []
      (components + [RAILS_ROOT]).each do |component_root|
        paths << "#{component_root}/app"
        paths << "#{component_root}/app/models"
        paths << "#{component_root}/app/controllers"
        paths << "#{component_root}/app/helpers"
        paths << "#{component_root}/lib"
      end
      paths
    end

    def files_on_load_path(file)
      component_fu_file_exists = false
      load_paths = []
      ComponentFu::ComponentManager.load_paths.each do |path|
        full_path = File.join(path, file)
        full_path_rb = "#{full_path}.rb"
        load_paths << full_path_rb if File.exists?(full_path_rb)
      end
      load_paths
    end
  end
end