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
              @items = Item.where(:category => @category.id, :is_approved => "y", salePrice: 0..params[:price_max].to_f).order("validTime DESC")
            end
          else #when price max contains only space
            @items = Item.where(:category => @category.id, :is_approved => "y").order("validTime DESC")
          end
        else # 0 0 LOGIC
          @items = Item.where(:category => @category.id, :is_approved => "y").order("validTime DESC")
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
              @items = Item.where(:category => @category.id, :is_approved => "y", salePrice: params[:price_min].to_f..params[:price_max].to_f).order("validTime DESC")
            end
          else # 1 0 LOGIC
            @items = Item.where(:category => @category.id, :is_approved => "y", salePrice: params[:price_min].to_f..99999999).order("validTime DESC")
          end
        end
      end

	    #META
	    set_meta_tags title: "Search in #{params[:name]}"
	    set_meta_tags description: "Find the best items from aliexpress in #{params[:name]} category"
	    set_meta_tags keywords: "aliexpress,category,products,deals"
	end

  def search_loop(search_phrase)  #uzywamy do ogolniejszego wyszukiwania jezeli wczesniej nic nie znaleziono
      search = "%"
      search_phrase = search_phrase
      params[:name].each do |param|
        search = search + "#{param}%"
      end
      @items = Item.where("productTitle like '%#{search}'")
      return @items
  end

	def search_item
    if request.GET[:name] != nil
      params[:name] = request.GET[:name]
    end
    puts params[:name]
	   if params[:p] == nil
			redirect_to search_item_path(params[:name], 1)
	   end
    params[:name] = params[:name].split #dzielimy podane haslo do wyszukiwania na pojedyncze wyrazy
    if params[:name].length > 1 #gdy ktos szuka wielu wyrazow
      search = "%"
      params[:name].each do |param|
        search = search + "#{param}%"
      end
		  @items = Item.where("productTitle like '%#{search}'%")
      if @items[0] == nil #jezeli nic nie znaleziono to skracamy fraze
        params[:name] = params[:name].slice(0..params[:name].length-2)
        puts params[:name]
        @items = search_loop(params[:name])
        if @items[0] == nil #jezeli po skroceniu nic nie znalezlismy to wypisujemy uzytkownikowi ze nic nie znalezlismy
          flash[:error] = "Sorry, we found nothing ;("
        end
      end
    else #gdy ktos szuka jednego wyrazu
      @items = Item.where("productTitle like '%#{params[:name][0]}'")
    end

	end

	def search_keyword
		@reviews = Review.where("keywords like '%#{params[:keyword]}%'")
	end

	def search_author
		@nickname = User.select(:id, :nickname).where(:nickname => params[:author]).first
		@reviews = Review.where(:author => @nickname.id)
	end
end