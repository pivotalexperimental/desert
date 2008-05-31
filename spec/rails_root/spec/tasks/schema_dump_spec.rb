require File.expand_path("#{File.dirname(__FILE__)}/../rails_spec_helper")

describe "rake db:schema:dump" do
  it "has an exit code of 0" do
    FileUtils.cd(RAILS_ROOT) do
      system("rake db:schema:dump -tv") || raise("db:schema:dump failed")
    end
  end
end