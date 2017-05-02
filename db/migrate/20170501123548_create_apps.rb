class CreateApps < ActiveRecord::Migration[5.0]
  def change
    create_table :apps do |t|
      t.string :name
      t.string :branch
      t.string :pr
      t.string :release
      t.integer :platform_id
      t.string :url
      t.timestamps
    end
  end
end
