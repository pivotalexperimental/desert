module ActionView #:nodoc:
  class TemplateFinder #:nodoc:
    def initialize_with_desert_plugins(*args)
      begin
        initialize_without_desert_plugins *args
      rescue ActionView::TemplateFinder::InvalidViewPath
        # Desert will add the missing paths next
      end
      Desert::Manager.plugins.reverse.each do |plugin|
        append_view_path plugin.templates_path
      end
    end
    alias_method_chain :initialize, :desert_plugins
  end
end
