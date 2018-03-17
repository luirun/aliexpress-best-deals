json.extract! user, :id, :nickname, :password, :password_digest, :name, :surname, :description, :email, :created_at, :updated_at
json.url user_url(user, format: :json)
