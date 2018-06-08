Rails.application.routes.draw do
  root "visitors#index"
  get "load-category", to: "visitors#new_products_append", as: "new_products_append"

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

  resource :user, only: [:show, :update, :edit], path: '/profile'
  get "/login", to: "sessions#new", as: "login"
  post "/login", to: "sessions#create"
  get "/logout", to: "sessions#destroy"

  resources :categories, except: [:index] do
    resources :subcategories
  end
  get "browse/categories", to: "categories#index", as: "products_categories"

  resources :reviews, param: :reviewTitle do
    resources :comments
  end
  get "/review/search-products/:name", to: "reviews#search_products", as: "search_review_products"

  resources :products, param: :productTitle do
    member do
      post "like", to: "products#product_like", as: "like"
      post "unlike", to: "products#product_unlike", as: "unlike"
    end
    collection { post :import }
  end
  get "product/:id/buy", to: "products#go_to_aliexpress", as: "aliexpress_pretty_url"
  get "get_subcategories/:category_id", to: "products#get_subcategory"

  # Search products in category
  get "category", to: "search#search_category_redirect", as: "redirect_to_search_in_category" # redirect category
  resources :category_search, controller: :search, path: 'category', param: :name do
    member do
      get "/:p", to: "search#search_category_with_filters", as: "products" # show category
      get "/:subcategory/:p", to: "search#search_category_with_filters", as: "subcategory" # show subcategorycategory
    end
  end

  resource :search do
    get "", to: "search#search_product", as: "redirect_to_products"
    get ":name/:p", action: :search_product, as: "product"
    get "keyword=:keyword", action: :search_keyword, as: "keyword"
    get "author=:author", action: :search_author, as: "author"
  end

  # admins routes
  get "/admins", to: "admins#index", as: :admins
  resource :admins, path: '/admins', only: [] do
    nested do
      scope :aliexpress_api, as: :aliexpress_api do
        # Search for products
        get "search_for_products", to: "admins#search_for_products", as: "products_search"
        post "list_found_products", to: "admins#list_found_products", as: "products_list"
        post "save_approved_products", to: "admins#save_approved_products", as: "products_save"

        # Searching for hot products by category
        get "hot_products_by_category", to: "admins#search_hot_products_by_category", as: "search_hot_products_by_category"
        post "hot_products_by_category", to: "admins#save_hot_products_by_category", as: "save_hot_products_by_category"

        # HACK: something is combined in these routes!
        # Search for all hot products/all not hot products in subcategories
        get "auto_save_hot_products", to: "admins#auto_hot_products", as: "save_hot_products_view"
        post "auto_save_hot_products", to: "admins#auto_hot_products", as: "save_hot_products"
        get "fill_all_subcategories", to: "admins#fill_all_subcategories", as: "fill_all_subcategories"

        # 4 - various clearing
        get "archive_expired_products", to: "admins#archive_expired_products", as: "archive_expired_products"
      end

      scope :scraping, as: :scraping do
        get "update_product_details", to: "admins#update_products_details", as: "update_products_details"
        get "fetch_categories", to: "admins#fetch_categories", as: "fetch_categories"
      end
    end

    get "delete_empty_reviews", to: "admins#delete_empty_reviews", as: "delete_empty_reviews"

    match "comments_manager", to: "admins#comments_manager", as: "comments_manager", via: [:get, :post]

    match "fill_category_from_file", to: "admins#fill_category_from_file", as: "fill_category_from_file", via: [:get, :post]

    # UNDONE: Article manager
    get "article_manage", to: "admins#article_manager", as: "article_manager"
  end

  # Error 404 path
  get "*path", to: "visitors#error404", as: "error" # error 404 page
end
