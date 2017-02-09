Rails.application.routes.draw do
  
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  #--------------------------------------------------------------------------------------------------

  #admins routes
  resources :admins
  get "admin/form" => "admins#search_items", as: "api_items_search"
  post "item_list" => "admins#list_items", as: "api_items_list"
  post "admin/saved_items" => "admins#save_items", as: "api_items_save"
  get "hot_products" => "items#hot_products", as: "api_hot_products"
  post "hot_products" => "items#save_hot_products", as: "api_save_hot_products"
  get "auto_save_hot_products" => "admins#auto_hot_products", as: "api_auto_save_hot_products"
  post "auto_save_hot_products" => "admins#auto_hot_products", as: "api_auto_save_hot_products_post"
  get "clear_expired_items" => "admins#clear_expired_items", as: "api_clear_expired_items"
    #admin article manager
    get "article_manage" => "admins#article_manager", as: "article_manager"

    #admin comment manager
    get "comments_manager" => "admins#comments_manager", as: "comments_manager"
    post "comments_manager_update" => "admins#comments_manager_update", as: "comments_manager_update"

    #fill category from file
    get "fill-category-from-file" => "admins#from_file", as: "from_file"
    post "fill-category-from-file/save" => "admins#save_from_file", as: "save_from_file"
  #-------------------------------------------------------------------------------------------------

  #comments routes
  resources :comments

  #-------------------------------------------------------------------------------------------------
 
  #users routes
  resources :users
  get "/profile" => "users#profile", as: "user_profile"
	
  #-------------------------------------------------------------------------------------------------

  #index page routing
	root 'visitors#index'
  get "load-category" => "visitors#new_items_append", :as => "new_items_append"
	
  #-------------------------------------------------------------------------------------------------

	resources :categories
	resources :subcategories
	resources :subsubcategories

  #review routes
  get "review/:reviewTitle" => "reviews#show", as: "review"
  get "review/:reviewTitle/edit" => "reviews#edit", as: "edit_review"
  get "/review/search-items/:name" => "reviews#search_items"
  patch "review/:id" => "reviews#update"
  delete "review/:id" => "reviews#destroy"
	resources :reviews


  #users routes
	resources :users
  
  #items routes
  get "product/:productTitle" => "items#show", as: "item"
  delete "product/:productTitle" => "items#destroy"
  get "product/:id/buy" => "items#go_to_aliexpress", as: "aliexpress_pretty_url"
	resources :items do
		collection { post :import }
	end
	   

     #various routes
    	get "get_subcategories/:category_id" => "items#get_subcategory"

      #search routes
      get "category/:name" => "categories#search", as: "redirect_to_search_in_category" #redirect category
      get "category/:name/:p" => "search#search_category", as: "search_category_items" #show category
      get "search" => "search#search_item", as: "redirect_to_search_items" #redirect items
      get "search/:name/:p" => "search#search_item", as: "search_item" #show items
      get "search/keyword=:keyword" => "search#search_keyword", as: "search_keyword"
      get "search/author=:author" => "search#search_author", as: "search_author"


      #404 erorrs
      get "*path" => "visitors#error404", as: "error"
end
