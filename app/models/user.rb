class User < ActiveRecord::Base
  has_secure_password
  validates :user_email, presence: true, uniqueness: true
  belongs_to :cluster
end
