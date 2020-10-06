json.extract! user, :id, :name, :surname, :balans, :created_at, :updated_at
json.url user_url(user, format: :json)
