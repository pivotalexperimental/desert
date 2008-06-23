class InitialSchema < ActiveRecord::Migration
  def self.up
    migrate_plugin :super_spiffy, 1
  end

  def self.down
    
  end
end