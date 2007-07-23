class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.column :content, :string, :null => false
      t.column :article_id, :integer, :null => false
    end
  end
  
  def self.down
    drop_table :comments
  end
end