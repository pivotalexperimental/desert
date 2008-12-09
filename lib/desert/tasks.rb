dir = File.dirname(__FILE__)
Dir["#{dir}/tasks/*.rake"].each do |file|
  load file
end