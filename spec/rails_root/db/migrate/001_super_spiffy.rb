class SuperSpiffy < ActiveRecord::Migration
  def self.up
    migrate_plugin :super_spiffy, 1
    migrate_plugin :super_spiffy, 2
    migrate_plugin :super_spiffy, 3
  end

  def self.down
    
  end
end