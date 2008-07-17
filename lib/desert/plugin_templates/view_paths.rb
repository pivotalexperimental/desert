if ActionView::Base.instance_methods.include?('view_paths')
  dir = File.dirname(__FILE__)
  require "#{dir}/view_paths/1.99.0/append_to_view_path"
end