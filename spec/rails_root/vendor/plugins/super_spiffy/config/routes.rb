ActionController::Routing::Routes.draw do |map|
  map.routes_from_plugin :acts_as_spiffy

  map.super_spiffy '/spiffy/super', :controller => "spiffy/spiffy", :action => 'super_spiffy'
end