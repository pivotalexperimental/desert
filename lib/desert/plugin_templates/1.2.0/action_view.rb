module ActionView
  class Base
    attr_reader :view_paths
    def initialize_with_desert(base_path = nil, assigns_for_first_render = {}, controller = nil)
      initialize_without_desert(base_path, assigns_for_first_render, controller)

      @view_paths = [base_path]
      Desert::Manager.plugins_and_app.reverse.each do |plugin|
        @view_paths << plugin.templates_path
      end
    end
    alias_method_chain :initialize, :desert

    private
    def full_path_template_exists?(path, extension)
      file_path = "#{path}.#{extension}"
      @@method_names.has_key?(file_path) || FileTest.exists?(file_path)
    end

    def find_template_extension_for(template_path)
      view_paths.each do |view_path|
        full_path = "#{view_path}/#{template_path}"
        if match = @@template_handlers.find { |k,| full_path_template_exists?(template_path, k) }
          return match.first.to_sym
        elsif full_path_template_exists?(full_path, :rhtml)
          return :rhtml
        elsif full_path_template_exists?(full_path, :rxml)
          return :rxml
        elsif full_path_template_exists?(full_path, :rjs)
          return :rjs
        end
      end
      raise ActionViewError, "No rhtml, rxml, rjs or delegate template found for #{template_path} in #{@base_path}"
    end

    def full_template_path_with_plugin_routing(template_path, extension)
      full_template_path = full_template_path_without_plugin_routing(template_path, extension)

      unless File.exist?(full_template_path)
        # Look through the plugins for the template
        Desert::Manager.plugins.reverse.each do |plugin|
          if plugin_template_path = plugin.find_template("#{template_path}.#{extension}")
            full_template_path = plugin_template_path
            break
          end
        end
      end

      full_template_path
    end
    alias_method_chain :full_template_path, :plugin_routing
  end
end