class AddWorkingToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :working, :boolean
    add_column :tasks, :working_start_time, :datetime
  end
end
