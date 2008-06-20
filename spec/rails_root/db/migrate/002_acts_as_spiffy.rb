class ActsAsSpiffy < ActiveRecord::Migration
  def self.up
    migrate_plugin :acts_as_spiffy, 1
    migrate_plugin :acts_as_spiffy, 2
  end

  def self.down
    
  end
end