json.extract! item, :id, :name, :image, :url, :price, :quanity_sold, :commision, :out_of_stock, :discount, :aff_url, :created_at, :updated_at
json.url item_url(item, format: :json)