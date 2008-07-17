dir = File.dirname(__FILE__)
if ActionView.const_defined?(:TemplateFinder)
  require "#{dir}/2.1.0/action_view"
else
  if ActionView::Base.private_instance_methods.include?('find_template_extension_from_handler')
    if ActionView::Base.instance_methods.include?('template_handler_preferences')
      require "#{dir}/1.99.0/action_view"
    else
      require "#{dir}/2.0.2/action_view"
    end
  elsif ActionView.const_defined?(:PathSet)
    require "#{dir}/edge/action_view"
  else
    require "#{dir}/1.2.0/action_view"
  end
end