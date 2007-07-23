module ActionView #:nodoc:
  class Base #:nodoc:
    private
      def full_template_path_with_plugin_routing(template_path, extension)
        full_template_path = full_template_path_without_plugin_routing(template_path, extension)
        
        unless File.exist?(full_template_path)
          # Look through the plugins for the template
          Rails.plugins.by_precedence do |plugin|
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