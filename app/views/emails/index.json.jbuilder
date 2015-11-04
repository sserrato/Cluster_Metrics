json.array!(@emails) do |email|
  json.extract! email, :id, :email_domain, :bridge, :bridge_global, :email_frequency, :month, :year, :cluster_id
  json.url email_url(email, format: :json)
end
