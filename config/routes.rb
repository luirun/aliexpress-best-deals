Rails.application.routes.draw do
  
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'


  resources :comments
  resources :users
  get "/profile" => "users#profile", as: "user_profile"
	
	root 'visitors#index'
	
	resources :categories
	resources :subcategories
	resources :subsubcategories
	resources :reviews
	resources :users
  
	resources :items do
		collection { post :import }
	end
	
    	get "get_subcategories/:category_id" => "items#get_subcategory"
      get "aliapi/form" => "visitors#search_items", as: "api_items_search"
    	post "item_list" => "visitors#list_items", as: "api_items_list"
      post "saved_items" => "visitors#save_items", as: "api_items_save"
      get "hot_products" => "items#hot_products", as: "api_hot_products"
      post "hot_products" => "items#save_hot_products", as: "api_save_hot_products"
      get "auto_save_hot_products" => "items#auto_hot_products", as: "api_auto_save_hot_products"

      get "search/:keyword" => "reviews#search_review", as: "search_keyword"
      get "search/author/:keyword" => "reviews#search_user", as: "search_user"
      get "category/:name/:p" => "categories#search", as: "search_in_category"
      get "category/:name" => "categories#search", as: "redirect_to_search_in_category"

      get "search" => "items#search", as: "search_item"
      get "search/:name/:p" => "items#search", as: "search_item_details"


      #search items routing


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end