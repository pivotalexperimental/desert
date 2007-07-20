class SpecSuite
  def run
    dir = File.dirname(__FILE__)
    system("ruby #{dir}/unit_spec_suite.rb") || raise("Unit Spec Suite failed")
    system("ruby #{dir}/rails_root/spec/rails_spec_suite.rb") || raise("Rails Spec Suite failed")
  end
end

if $0 == __FILE__
  SpecSuite.new.run
end