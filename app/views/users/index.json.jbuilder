json.array!(@users) do |user|
  json.extract! user, :id, :first_name, :last_name, :access_permission, :user_email, :password_digest, :cluster_id
  json.url user_url(user, format: :json)
end
