class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.integer :user_id
      t.string :title
      t.text :description
      t.string :difficulty
      t.datetime :deadline
      t.float :completion_percentage
      t.integer :completion_time
      t.boolean :completed

      t.timestamps
    end
  end
end
