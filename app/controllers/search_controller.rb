class SearchController < ApplicationController
	def search_category
      @category = Category.where(:name => params[:name]).first

      #checking that pagination exsists, if not redirecting to 1 page
      if params[:p] == nil
        redirect_to search_in_category_path(params[:name], 1)
      end

      #price_min, price_max - 0 ? LOGIC
      if params[:price_min] == nil || params[:price_min] == "" #0 ? LOGIC
        if params[:price_max] != nil # 0 1 LOGIC
          if params[:price_max] != "" #price max not contain empty space
            if params[:price_max].to_f <= 0
              flash[:notice] = "Price max must be higher than zero!"
              redirect_to search_in_category_path(params[:name], params[:p])
            else # 0 1 LOGIC
              @items = Item.where(:category => @category.id, :is_approved => "y", salePrice: 0..params[:price_max].to_f)
            end
          else #when price max contains only space
            @items = Item.where(:category => @category.id, :is_approved => "y")
          end
        else # 0 0 LOGIC
          @items = Item.where(:category => @category.id, :is_approved => "y")
        end
      else
        if params[:price_min].to_f < 0
          flash[:notice] = "Price min must be higher than zero!"
          redirect_to search_in_category_path(params[:name], params[:p])
        else #PRICE MIN > 0
          puts params[:price_max]
          if params[:price_max] != "" # PRICE MAX != EMPTY
            if params[:price_min] > params[:price_max] # min higher than max
              flash[:notice] = "Maximum price must be higher than minimal price!"
              redirect_to search_in_category_path(params[:name], params[:p])
            else # 1 - 1 LOGIC
              @items = Item.where(:category => @category.id, :is_approved => "y", salePrice: params[:price_min].to_f..params[:price_max].to_f)
            end
          else # 1 0 LOGIC
            @items = Item.where(:category => @category.id, :is_approved => "y", salePrice: params[:price_min].to_f..99999999)
          end
        end
      end

	    #META
	    set_meta_tags title: "Search in #{params[:name]}"
	    set_meta_tags description: "Find the best items from aliexpress in #{params[:name]} category"
	    set_meta_tags keywords: "aliexpress,category,products,deals"
	end

	def search_item
	   	if params[:p] == nil
			redirect_to search_item_path(params[:name], 1)
	    end
		@items = Item.where("productTitle like '%#{params[:name]}%'")
	end

	def search_keyword
		@reviews = Review.where("keywords like '%#{params[:keyword]}%'")
	end

	def search_author
		@nickname = User.select(:id, :nickname).where(:nickname => params[:author]).first
		@reviews = Review.where(:author => @nickname.id)
	end
end