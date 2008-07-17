module ActionView #:nodoc:
  class Base #:nodoc:
    def initialize_with_desert_plugins(*args)
      initialize_without_desert_plugins *args

      Desert::Manager.plugins.reverse.each do |plugin|
        view_paths << plugin.templates_path
      end
    end
    alias_method_chain :initialize, :desert_plugins
    
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
  end
end
