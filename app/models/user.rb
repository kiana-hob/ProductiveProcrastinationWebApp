# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string
#  employed        :boolean
#  password_digest :string
#  student         :boolean
#  username        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
  validates :email, :uniqueness => { :case_sensitive => false }
  validates :email, :presence => true
  has_secure_password
  has_many(:tasks, { :class_name => "Task", :foreign_key => "user_id", :dependent => :destroy })
end
