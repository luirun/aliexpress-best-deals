class AliReview < ApplicationRecord
  belongs_to :product

  scope :non_empty_reviews_of_product, ->(product) { where(productId: product.productId, is_empty: 'n') }
  scope :empty_reviews, -> { where(is_empty: 'y').where('length(review_content) < ?', 5) }

  def self.calculate_product_rating(reviews)
    return if reviews.count.zero?

    product_rating  = { one: 0.0, two: 0.0, three: 0.0, four: 0.0, five: 0.0 }
    product_rating[:avg] = 0
    reviews.each do |review|
      product_rating[:avg] += review.user_order_rate
      case review.user_order_rate
      when 100
        product_rating[:five] += 1
      when 80
        product_rating[:four] += 1
      when 60
        product_rating[:three] += 1
      when 40
        product_rating[:two] += 1
      when 20
        product_rating[:one] += 1
      end
    end
    product_rating[:avg] = (product_rating[:avg] / reviews.count) / 20.round(1)
    product_rating
  end

  def save_product_reviews(reviews, product_id)
    i = 0
    if reviews[:feedback][0].nil? # if there is no reviews on aliexpress we are creating an empty one with is_empty = 'y'
      review = AliReview.new
      review.is_empty = 'y'
      review.productId = product_id
      review.save
      product = Product.find_by(productId: product_id)
      product.with_reviews = 'y'
      product.save
    else
      reviews[:feedback].each do |feedback| # saving every not empty review with user details
        review = AliReview.new
        review.productId = product_id
        review.username = reviews[:user_info][i]['username']
        review.user_country = reviews[:user_info][i]['user_country']
        review.user_order_rate = feedback['user_order_rate']
        review.user_order_info = feedback['user_order_info']
        review.review_content = feedback['user_review']
        review.review_date = feedback['review_date']
        review.review_photos = feedback['review_photos'].join(',')
        review.is_empty = 'n'
        review.save
        i += 1
      end
      product = Product.find_by(productId: product_id)
      product.with_reviews = 'y'
    end
    product.save
  end

  def delete_empty_reviews(reviews)
    reviews.delete_all
  end
end
