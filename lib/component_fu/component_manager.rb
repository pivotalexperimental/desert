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
      components.each do |component_root|
        paths << "#{component_root}/app"
        paths << "#{component_root}/app/models"
        paths << "#{component_root}/app/controllers"
        paths << "#{component_root}/app/helpers"
        paths << "#{component_root}/lib"
      end
      paths
    end
  end
end