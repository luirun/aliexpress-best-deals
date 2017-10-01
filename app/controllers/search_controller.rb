class SearchController < ApplicationController

  def search_category_redirect; redirect_to search_category_items_path(params[:name], 1); end
	def search_category
      @category = Category.where(:name => params[:name]).first
      @subcategories = Subcategory.where(:parent => @category.id).distinct
      #checking that pagination exsists, if not redirecting to 1 page
      if params[:p] == nil
        redirect_to search_category_path(params[:name], 1)
      end
      
      params[:price_min] = params[:price_min].to_f
      params[:price_max] = params[:price_max].to_f
      if params[:price_max] == 0.0 then params[:price_max] = 9999.99 else params[:price_max] = params[:price_max].to_f end
      
      if params[:price_min] != 0.0
        if params[:price_min] < params[:price_max] then min_price = params[:price_min] else flash[:notice] = "Minimal price can't be higher than maximum price!";min_price = 9999;redirect_to request.referer end
      else
        min_price = 0.0 
      end

      if params[:price_max] != 9999.99
        if params[:price_max] > params[:price_min] then max_price = params[:price_max] else flash[:notice] = "Minimal price can't be higher than maximum price!";max_price = 1;redirect_to request.referer end
      else 
        max_price = 9999.99
      end
      
      if min_price < 0 || max_price <= 0
        flash[:notice] = "You can't search for products cheaper than 0.01$!"; redirect_to request.referer;
      else
        if params[:subcategory] == nil
          @items = Item.where(:category => @category.id, salePrice: min_price..max_price, :with_reviews => "y")
        else
          @items = Item.where(:category => @category.id, subcategory: @subcategories.where(:name => params[:subcategory]).first.id, salePrice: min_price..max_price, :with_reviews => "y")
        end
      end
      
      #when user search for subcategory - we are setting subcategory_id variable
      if params[:subcategory] != nil
        subcategory_id = @subcategories.where(:name => params[:subcategory]).first.id
        @items = @items.where(:subcategory => subcategory_id)
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
    if request.GET[:name] != nil #jezeli w gecie nie bedzie nazwy to uzywaj starej, jesli jest to zastap parametr - przydatne kiedy szukasz z strony szukania
      params[:name] = request.GET[:name]
    end
	   if params[:p] == nil
			redirect_to search_item_path(params[:name], 1)
	   end
    params[:name] = params[:name].split #dzielimy podane haslo do wyszukiwania na pojedyncze wyrazy
    if params[:name].length > 1 #gdy ktos szuka wielu wyrazow
      search = "%"
      params[:name].each do |param|
        search = search + "#{param}%"
      end
		  @items = Item.where("productTitle like '%#{search}'")
      if @items[0] == nil #jezeli nic nie znaleziono to skracamy fraze
        params[:name] = params[:name].slice(0..params[:name].length-2)
        puts params[:name]
        @items = search_loop(params[:name])
        if @items[0] == nil #jezeli po skroceniu nic nie znalezlismy to wypisujemy uzytkownikowi ze nic nie znalezlismy
          flash[:error] = "Sorry, we found nothing ;("
        end
      end
    else #gdy ktos szuka jednego wyrazu
      @items = Item.where("productTitle like '%#{params[:name][0]}%'")
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