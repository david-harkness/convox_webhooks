class CreateApps < ActiveRecord::Migration[5.0]
  def change
    create_table :apps do |t|
      t.string :name
      t.string :platform_id
      t.string :integer
      t.string :url

      t.timestamps
    end
  end
end
