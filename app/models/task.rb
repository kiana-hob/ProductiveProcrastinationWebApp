# == Schema Information
#
# Table name: tasks
#
#  id                    :integer          not null, primary key
#  completed             :boolean
#  completion_percentage :float
#  completion_time       :integer
#  deadline              :datetime
#  description           :text
#  difficulty            :string
#  title                 :string
#  working               :boolean
#  working_start_time    :datetime
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  user_id               :integer
#
class Task < ApplicationRecord
  belongs_to(:user, { :required => false, :class_name => "User", :foreign_key => "user_id" })
end
