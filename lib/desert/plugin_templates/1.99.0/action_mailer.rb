module ActionMailer #:nodoc
  class Base #:nodoc:
    private
      def template_path_with_plugin_routing
        template_paths = [template_path_without_plugin_routing]
        Desert::Manager.plugins.reverse.each do |plugin|
          template_paths << "#{plugin.templates_path}/#{mailer_name}"
        end
        "{#{template_paths * ','}}"
      end
      alias_method_chain :template_path, :plugin_routing

      def initialize_template_class(assigns)
        view_path = File.dirname(Dir["#{template_path}/#{@template}.*"].first)
        returning(template = ActionView::Base.new([view_path], assigns, self)) do
          template.extend ApplicationHelper
          template.extend self.class.master_helper_module
        end
      end
  end
end