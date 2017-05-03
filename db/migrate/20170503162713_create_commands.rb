class CreateCommands < ActiveRecord::Migration[5.0]
  def change
    create_table :commands do |t|
      t.integer :job_id
      t.integer :step
      t.text :cli
      t.text :output
      t.integer :status_code
      t.boolean :success

      t.timestamps
    end
  end
end
