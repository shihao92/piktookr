json.extract! user, :id, :email, :password, :password_confirmation, :name, :status, :avatar, :role, :created_at, :updated_at
json.url user_url(user, format: :json)