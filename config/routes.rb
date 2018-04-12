Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  devise_scope :user do
    get "/register", to: "users/registrations#new", as: "new_user" # custom path to sign_up/registration
    post "/register", to: "users/registrations#create", as: "create_user"
    #post '/login' => 'users/sessions#create', :as => :session
  end

  mount Ckeditor::Engine => "/ckeditor"
  get "/login", to: "sessions#new", as: "login"
  post "/login", to: "sessions#create"
  get "/logout", to: "sessions#destroy"

  # --------------------------------------------------------------------------------------------------

  # admins routes
  resources :admins

  # 1 - searching for products
  get "admin/search_for_products", to: "admins#search_for_products", as: "api_products_search"
  post "admin/list_found_products", to: "admins#list_found_products", as: "api_products_list"
  post "admin/save_approved_products", to: "admins#save_approved_products", as: "api_products_save"
  # ---------------- 1 end ------------------

  # 2 - searching for hot products by category
  get "hot_products_by_category", to: "admins#hot_products_by_category", as: "api_hot_products_by_category"
  post "hot_products_by_category", to: "admins#save_hot_products_by_category", as: "api_save_hot_products_by_category"
  # ---------------- 2 end ------------------

  # 3 - search for all hot products/all not hot products in subcategories
  get "auto_save_hot_products", to: "admins#auto_hot_products", as: "api_auto_save_hot_products"
  post "auto_save_hot_products", to: "admins#auto_hot_products", as: "api_auto_save_hot_products_post"
  get "mass_subcategory_filling", to: "admins#mass_subcategory_filling", as: "mass_subcategory_filling"
  # ---------------- 3 end ------------------

  # 4 - various clearing
  get "archive_expired_products", to: "admins#archive_expired_products", as: "api_archive_expired_products"
  get "delete_empty_reviews", to: "admins#delete_empty_reviews", as: "delete_empty_reviews"
  # ---------------- 4 end ------------------

  # 5 - admin comment manager
  get "comments_manager", to: "admins#comments_manager", as: "comments_manager"
  post "comments_manager_update", to: "admins#comments_manager_update", as: "comments_manager_update"
  # ---------------- 5 end ------------------

  # 6 - fill category from file
  get "fill_category_from_file", to: "admins#from_file", as: "from_file"
  post "save_from_file", to: "admins#save_from_file", as: "save_from_file"
  # ---------------- 6 end ------------------

  # 7 - fetch product and category details
  get "update_product_details", to: "admins#update_products_details", as: "update_products_details"
  get "fetch_categories", to: "admins#fetch_categories", as: "fetch_categories"
  # ---------------- 7 end ------------------

  # admin article manager - UNDONE!
  get "article_manage", to: "admins#article_manager", as: "article_manager"
  # -------------------------------------------------------------------------------------------------

  # comments routes
  resources :comments
  # -------------------------------------------------------------------------------------------------

  # users routes
  # get "register", to: "users#new", as: "new_user"
  resources :users
  get "/profile", to: "users#profile", as: "user_profile"

  # ----------------------------------------------------------------------------------------

  # index page routing
  root "visitors#index"
  get "load-category", to: "visitors#new_products_append", as: "new_products_append"

  # ----------------------------------------------------------------------------------------

  resources :categories
  resources :subcategories
  resources :subsubcategories

  # Review routes
  get "review/:reviewTitle", to: "reviews#show", as: "review"
  get "review/:reviewTitle/edit", to: "reviews#edit", as: "edit_review"
  get "/review/search-products/:name", to: "reviews#search_products", as: "search_review_products"
  patch "review/:id", to: "reviews#update"
  delete "review/:id", to: "reviews#destroy"
  resources :reviews

  # users routes
  resources :users

  # products routes
  get "product/:productTitle", to: "products#show", as: "product"
  post "product/:productTitle/like", to: "products#product_like", as: "product_like"
  post "product/:productTitle/unlike", to: "products#product_unlike", as: "product_unlike"
  get "browse/products", to: "products#index", as: "products"
  delete "product/:productTitle", to: "products#destroy"
  get "product/:id/buy", to: "products#go_to_aliexpress", as: "aliexpress_pretty_url"
  # get "/:category/:productTitle/:productId", to: "products#similar_product", as: "add_similar_product"
  resources :products do
    collection { post :import }
  end

  # various routes
  get "get_subcategories/:category_id", to: "products#get_subcategory"

  # search routes
  # 1 - Search products in category
  get "category/:name", to: "search#search_category_redirect", as: "redirect_to_search_in_category" # redirect category
  get "category/:name/:p", to: "search#search_category_with_filters", as: "search_category_products" # show category
  get "category/:name/:subcategory/:p", to: "search#search_category_with_filters", as: "search_subcategory" # show subcategorycategory

  # 2 - Search product by params in URL
  get "search", to: "search#search_product", as: "redirect_to_search_products" # redirect products
  get "search/:name/:p", to: "search#search_product", as: "search_product" # show products

  # 3 - Find reviews by keywords
  get "search/keyword=:keyword", to: "search#search_keyword", as: "search_keyword"

  # 4 - Find reviews by author
  get "search/author=:author", to: "search#search_author", as: "search_author"

  # 404 erorrs
  get "*path", to: "visitors#error404", as: "error"
end
