class OnlyOneCreate < ActiveRecord::Migration[5.0]
  def change
    add_column :apps, :created, :boolean, :default => false, :null => false
    add_column :apps, :status, :string, :default => 'Not Created', :null => false
  end
end
