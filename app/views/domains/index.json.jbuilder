json.array!(@domains) do |domain|
  json.extract! domain, :id, :url, :sat_bridge, :cluster_id, :global_bridge
  json.url domain_url(domain, format: :json)
end
