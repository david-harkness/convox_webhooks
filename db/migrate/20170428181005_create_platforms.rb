class CreatePlatforms < ActiveRecord::Migration[5.0]
  def change
    create_table :platforms do |t|
      t.string :name
      t.string :login
      t.string :auth_code  # Secret!
      t.string :git_repo
      t.string :git_secret # Secret!
      t.timestamps
    end
  end
end
