class TasksController < ApplicationController

  def new 

    render({:template => "tasks/new_task.html.erb"})
  end

  def completed 

    task_id = params.fetch("path_id")
    @matching_task = Task.where({:id => task_id}).first 
    @matching_task.completed = true 
    @matching_task.save
    redirect_to("/tasks", { :notice => "Task completed!"} )
  end

  def start
    # @start_timer = Time.now 
    # @current_timer = Time.now 
    # @working_time = @current_time - @start_time
    task_id = params.fetch("path_id")
    the_task = Task.where({:id => task_id}).first
    twilio_receiving_number = @current_user.phone

    completion_time = (the_task.completion_time/60).to_s + " hours and " + (the_task.completion_time%60).to_s + " minutes to complete. Good Luck!"
    twilio_message = "You've started working on the task: " + the_task.title + ". You estimated that it would take " + completion_time

    # Retrieve your credentials from secure storage
    twilio_sid = ENV.fetch("TWILIO_ACCOUNT_SID")
    twilio_token = ENV.fetch("TWILIO_AUTH_TOKEN")
    twilio_sending_number = ENV.fetch("TWILIO_SENDING_PHONE_NUMBER")

    # Create an instance of the Twilio Client and authenticate with your API key
    twilio_client = Twilio::REST::Client.new(twilio_sid, twilio_token)

    # Craft your SMS as a Hash with three keys
    sms_parameters = {
      :from => twilio_sending_number,
      :to => +13129754207,#twilio_receiving_number, # Put your own phone number here if you want to see it in action
      :body => twilio_message
    }

    # Send your SMS!
    twilio_client.api.account.messages.create(sms_parameters)


    redirect_to("/tasks", { :notice => "Task Started!"} )
  end


  def index
    matching_tasks = @current_user.tasks

    @list_of_tasks = matching_tasks.order({ :created_at => :desc })
    @todays_date = DateTime.now.to_date
    @list_of_easy_tasks = matching_tasks.where({ :difficulty => "Easy", :completed => false}).order({ :created_at => :desc })
    @list_of_medium_tasks = matching_tasks.where({ :difficulty => "Medium", :completed => false}).order({ :created_at => :desc })
    @list_of_hard_tasks = matching_tasks.where({ :difficulty => "Hard", :completed => false}).order({ :created_at => :desc })

    @list_of_completed_tasks = matching_tasks.where({ :completed => true}).order({ :updated_at => :desc})
    render({ :template => "tasks/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_tasks = Task.where({ :id => the_id })

    @the_task = matching_tasks.at(0)

    render({ :template => "tasks/show.html.erb" })
  end

  def create
    the_task = Task.new
    the_task.user_id = @current_user.id
    the_task.title = params.fetch("query_title")
    the_task.description = params.fetch("query_description")
    the_task.difficulty = params.fetch("query_difficulty")

    # Convert form data and time to datetime data type
    deadline_date = params.fetch("query_deadline_date").split("-")
    deadline_time = params.fetch("query_deadline_time").split(":")
    
    if (deadline_date != nil)
      year = deadline_date[0].to_i
      month = deadline_date[1].to_i
      day = deadline_date[2].to_i
      hour = deadline_time[0].to_i
      minute = deadline_time[1].to_i
      if (deadline_time != nil)
        the_task.deadline = DateTime.new(year, month, day, hour, minute)
      else
        the_task.deadline = DateTime.new(year, month, day, 23, 59)
      end
    end


    the_task.completion_percentage = 0
    completion_hour = params.fetch("query_completion_time_hour").to_i * 60
    completion_minute = params.fetch("query_completion_time_min").to_i

    the_task.completion_time = completion_hour + completion_minute

    the_task.completed = false

    if the_task.valid?
      the_task.save
      redirect_to("/tasks", { :notice => "Task created successfully." })
    else
      redirect_to("/tasks", { :notice => "Task failed to create successfully." })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_task = Task.where({ :id => the_id }).at(0)

    the_task.user_id = params.fetch("query_user_id")
    the_task.title = params.fetch("query_title")
    the_task.description = params.fetch("query_description")
    the_task.difficulty = params.fetch("query_difficulty")
    the_task.deadline = params.fetch("query_deadline")
    the_task.completion_percentage = params.fetch("query_completion_percentage")
    the_task.completion_time = params.fetch("query_completion_time")
    the_task.completed = params.fetch("query_completed", false)

    if the_task.valid?
      the_task.save
      redirect_to("/tasks/#{the_task.id}", { :notice => "Task updated successfully."} )
    else
      redirect_to("/tasks/#{the_task.id}", { :alert => "Task failed to update successfully." })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_task = Task.where({ :id => the_id }).at(0)

    the_task.destroy

    redirect_to("/tasks", { :notice => "Task deleted successfully."} )
  end
end
