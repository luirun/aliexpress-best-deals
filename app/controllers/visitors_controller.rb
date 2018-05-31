class VisitorsController < ApplicationController
  def index
    @recent_reviews = Review.limit(3).order("id desc")
    @categories = Category.all.sample(3)
    @best_products = Product.where(is_hot: 'y').limit(32).sample(16)
    session[:excluded_categories] = []

    # META
    set_meta_tags title: "Aliexpress Best Deals"
    set_meta_tags description: "Here you can find new hot products from AliExpress with reviews and user feedback! Buy smarter with us!"
    set_meta_tags keywords: "aliexpress,deal,review,shipping,how to buy,faq,prices,products,deals,find,review,test"
  end

  def hot_products; end

  def new_products_append
    @categories = Category.where.not(id: session[:excluded_categories]).sample(3)
    respond_to do |format|
      format.js
    end
  end

  def error404
    # META
    set_meta_tags title: "404 Page not found!"
    set_meta_tags description: "This page doesnt exist! But you may back to our home page and discover our website!"
    set_meta_tags keywords: "aliexpress,deal,review,error,page,404"
  end
end
