json.extract! photo, :id, :title, :photo, :photo_url, :created_at, :updated_at
json.url photo_url(photo, format: :json)
