desc "Hydrate the database with some sample data to look at so that developing is easier"
task({ :sample_data => :environment}) do
  current_user = User.new
  current_user.password = "password"
  current_user.password_confirmation = "password"
  current_user.email = "kiana@example.com"
  current_user.phone = "+13129754207"
  current_user.save

  for i in 1..15 do
    the_task = Task.new
    the_task.user_id = current_user.id
    the_task.title = "Sample Task " +  i.to_s
    the_task.description = "Sample Description " + i.to_s
    if i > 10
      the_task.difficulty = "Easy"
    elsif i > 5
      the_task.difficulty = "Medium"
    else
      the_task.difficulty = "Hard"
    end

    the_task.deadline = DateTime.new(2020, 12, i, 23, 59)
  
    the_task.completion_percentage = 0

    the_task.completion_time = i 

    the_task.completed = false
    the_task.save
  end

end
