json.extract! post, :id, :tytul, :krotki_opis, :dlugi_opis, :tagi, :created_at, :updated_at
json.url post_url(post, format: :json)