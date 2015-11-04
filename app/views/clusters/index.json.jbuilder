json.array!(@clusters) do |cluster|
  json.extract! cluster, :id, :cluster_name
  json.url cluster_url(cluster, format: :json)
end
