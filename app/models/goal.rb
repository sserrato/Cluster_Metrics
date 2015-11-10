class Goal < ActiveRecord::Base
  belongs_to :clusters

  #diversity goals
  scope :diversity_goals, ->(cluster_value){where("cluster_id = '?'", cluster_value).where("sat_bridge <> '9998' AND sat_bridge <> 0").pluck("diversity")}

end
