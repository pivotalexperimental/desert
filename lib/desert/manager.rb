module Desert
  class Manager # nodoc
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

    attr_reader :loading_plugin, :plugins_in_registration

    def initialize
      @plugins = []
      @plugins_in_registration = []
    end

    def plugins
      @plugins.dup
    end

    def load_paths
      paths = []
      plugin_paths.each do |component_root|
        paths << File.join(component_root, 'app')
        paths << File.join(component_root, 'app','models')
        paths << File.join(component_root, 'app','controllers')
        paths << File.join(component_root, 'app','helpers')
        paths << File.join(component_root, 'lib')
      end
      dependencies.load_paths.reverse.each do |path|
        paths << File.expand_path(path) unless paths.include?(File.expand_path(path))
      end
      paths
    end

    def register_plugin(plugin_path)
      plugin = Plugin.new(plugin_path)
      @plugins_in_registration << plugin

      yield if block_given?

      dependencies.load_paths << plugin.models_path
      dependencies.load_paths << plugin.controllers_path
      dependencies.load_paths << plugin.helpers_path

      @plugins_in_registration.pop

      if existing_plugin = find_plugin(plugin.name)
        return existing_plugin
      end

      @plugins << plugin
      plugin
    end

    def find_plugin(name_or_directory)
      name = File.basename(File.expand_path(name_or_directory))
      plugins.find do |plugin|
        plugin.name == name
      end
    end

    def plugin_exists?(name_or_directory)
      !find_plugin(name_or_directory).nil?
    end

    def plugin_path(name)
      plugin = find_plugin(name)
      return nil unless plugin
      plugin.path
    end

    def files_on_load_path(file)
      desert_file_exists = false
      files = []
      load_paths.each do |path|
        full_path = File.join(path, file)
        full_path << '.rb' unless File.extname(full_path) == '.rb'
        files << full_path if File.exists?(full_path)
      end
      files
    end

    def directory_on_load_path?(dir_suffix)
      Desert::Manager.load_paths.each do |path|
        return true if File.directory?(File.join(path, dir_suffix))
      end
      return false
    end

    def layout_paths
      layout_paths = plugins.reverse.collect do |plugin|
        plugin.layouts_path
      end
      layout_paths
    end

    protected
    def dependencies
      @dependencies ||= ActiveSupport.const_defined?(:Dependencies) ? ActiveSupport::Dependencies : Dependencies
    end

    def plugin_paths
      plugins_and_app.collect { |plugin| plugin.path }
    end

    def plugins_and_app
      plugins + @plugins_in_registration + [Plugin.new(RAILS_ROOT)]
    end
  end
end
