class CreateEmployees < ActiveRecord::Migration
  def self.up
    create_table :employees do |t|
      t.column :company_id, :integer, :null => false
      t.column :first_name, :string, :null => false
      t.column :last_name, :string, :null => false
    end
  end
  
  def self.down
    drop_table :employees
  end
end