class CreateJobs < ActiveRecord::Migration[5.0]
  def change
    create_table :jobs do |t|
      t.integer :app_id
      t.string :job_type
      t.string :status
      t.integer :steps
      t.boolean :complete
      t.timestamps
    end
  end
end
