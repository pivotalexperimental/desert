require File.expand_path("#{File.dirname(__FILE__)}/../rails_spec_helper")

describe "rake db:schema:dump" do
  if RUBY_PLATFORM =~ /darwin/
    it "is disabled for desert tests on OSX, because it cannot activate sqlite3 gem via a system call to rake"
  else
    it "has an exit code of 0" do
      FileUtils.cd(RAILS_ROOT) do
        system("rake db:schema:dump -tv") || raise("db:schema:dump failed")
      end
    end
  end
end