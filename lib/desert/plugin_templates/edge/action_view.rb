ActionView::Base.class_eval do
  def initialize_with_desert_plugins(*args)
    initialize_without_desert_plugins *args

    Desert::Manager.plugins.reverse.each do |plugin|
      view_paths << plugin.templates_path
    end
  end
  alias_method_chain :initialize, :desert_plugins
end