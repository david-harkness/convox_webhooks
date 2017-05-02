class CreatePlatforms < ActiveRecord::Migration[5.0]
  def change
    create_table :platforms do |t|
      t.string :name
      t.string :login
      t.string :auth_code

      t.timestamps
    end
  end
end
