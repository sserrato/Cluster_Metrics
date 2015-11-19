class Domain < ActiveRecord::Base
  belongs_to :clusters
  validates :url, presence: true, uniqueness: true

end
