ActionController::Routing::Routes.draw do |map|
  map.routes_from_plugin :the_grand_poobah
  map.acts_as_spiffy '/spiffy/acts/as', :controller => "spiffy/spiffy", :action => 'acts_as_spiffy'
end