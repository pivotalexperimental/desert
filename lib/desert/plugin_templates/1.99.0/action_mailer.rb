module ActionMailer #:nodoc
  class Base #:nodoc:
    private
      def template_path_with_plugin_routing
        result = nil
        Desert::Manager.plugins_and_app.reverse.each do |plugin|
          relative_path = "#{plugin.templates_path}/#{mailer_name}"
          unless Dir["#{relative_path}/#{@template}.*"].empty?
            result = relative_path
            break
          end
        end
        result || template_path_without_plugin_routing
      end
      alias_method_chain :template_path, :plugin_routing

      def initialize_template_class(assigns)
        view_paths = Dir["#{template_path}/#{@template}.*"].collect do |path|
          File.dirname(path)
        end
        returning(template = ActionView::Base.new(view_paths, assigns, self)) do
          template.extend ApplicationHelper
          template.extend self.class.master_helper_module
        end
      end
  end
end