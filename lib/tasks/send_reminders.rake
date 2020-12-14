task({:send_reminder => :environment}) do 
  p Task.count
  working_task = Task.where({:working => true}).first
  current_time = Time.now
  working_start_time = working_task.working_start_time 
  time_passed = (current_time - working_start_time)/60

  #user 
  the_user = User.where({:id => working_task.user_id}).first
  phone_number = the_user.phone
  if time_passed % 30 == 0 and time_passed != 0
  
    twilio_receiving_number = phone_number

    working_time = (time_passed/60).to_s + " hours and " + (time_passed%60).to_s + " minutes"
    twilio_message = "You've been working on " + the_task.title + " for " + working_time + ". Keep up the hard work!"

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
  end
end