json.extract! user, :id, :name, :password_hash, :email, :created_at, :updated_at
json.url user_url(user, format: :json)