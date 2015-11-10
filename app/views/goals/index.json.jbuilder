json.array!(@goals) do |goal|
  json.extract! goal, :id, :bridge_name, :intensity, :diversity, :sat_bridge, :cluster_id
  json.url goal_url(goal, format: :json)
end
