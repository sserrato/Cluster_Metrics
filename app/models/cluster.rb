class Cluster < ActiveRecord::Base
  has_many :emails
  has_many :users
  has_many :goals 
end
