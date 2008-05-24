if ActionView.const_defined?(:TemplateFinder)
  module ActionView #:nodoc:
    class TemplateFinder #:nodoc:
      def initialize_with_desert_plugins(*args)
        initialize_without_desert_plugins *args
        
        Desert::Manager.plugins.reverse.each do |plugin|
          append_view_path plugin.templates_path
        end
      end
      alias_method_chain :initialize, :desert_plugins
    end
  end
else
  module ActionView #:nodoc:
    class Base #:nodoc:
      if private_instance_methods.include?('find_template_extension_from_handler')
        if instance_methods.include?('template_handler_preferences')
          # Rails 1.99.0
          def find_template_extension_from_handler(template_path, formatted = nil)
            checked_template_path = formatted ? "#{template_path}.#{template_format}" : template_path

            view_paths.each do |view_path|
              template_handler_preferences.each do |template_type|
                extensions =
                  case template_type
                  when :javascript
                    [:rjs]
                  when :delegate
                    @@template_handlers.keys
                  else
                    [template_type]
                  end

                extensions.each do |extension|
                  file_path = File.join(view_path, "#{checked_template_path}.#{extension}")
                  if File.exist?(file_path)
                    return formatted ? "#{template_format}.#{extension}" : extension.to_s
                  end
                end
              end
            end
            nil
          end
        else
          # Rails 2.0.2
          def find_template_extension_from_handler(template_path, formatted = nil)
            checked_template_path = formatted ? "#{template_path}.#{template_format}" : template_path

            view_paths.each do |view_path|
              self.class.template_handler_extensions.each do |extension|
                file_path = File.join(view_path, "#{checked_template_path}.#{extension}")
                if File.exist?(file_path)
                  return formatted ? "#{template_format}.#{extension}" : extension.to_s
                end
              end
            end
            nil
          end
        end
      end

      if instance_methods.include?('view_paths')
        def initialize_with_desert_plugins(*args)
          initialize_without_desert_plugins *args

          Desert::Manager.plugins.reverse.each do |plugin|
            view_paths << plugin.templates_path
          end
        end
        alias_method_chain :initialize, :desert_plugins
      else
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
  end
end