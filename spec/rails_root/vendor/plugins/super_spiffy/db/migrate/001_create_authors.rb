class CreateAuthors < ActiveRecord::Migration
  def self.up
    create_table :authors do |t|
      t.column :name, :string, :null => false
    end
  end
  
  def self.down
    drop_table :authors
  end
end