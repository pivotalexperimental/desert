module ActionMailer #:nodoc
  class Base #:nodoc:
    private
      def template_path_with_plugin_routing
        template_paths = [template_path_without_plugin_routing] + Rails.plugins.by_precedence.collect {|plugin| "#{plugin.templates_path}/#{mailer_name}"}
        "{#{template_paths * ','}}"
      end
      alias_method_chain :template_path, :plugin_routing
      
      def initialize_template_class(assigns)
        base_path = Dir["#{template_path}/#{@template}.*"].first
        base_path.gsub!(/\/#{@template}.*$/, '') if base_path
        
        returning(template = ActionView::Base.new(base_path, assigns, self)) do
          template.extend self.class.master_helper_module
        end
      end
  end
end