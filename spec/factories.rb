FactoryGirl.define do
  factory :product do
    id 11
    productId 32813027712
    productTitle "Laptop Ultraslim notebook 1920x1080 FHD Intel Cherry Trail"
    productDescription ""
    productUrl "https://www.aliexpress.com/item/13-3-Windows-10-Laptop-notebook-computer-1920x1080-FHD-Intel-Cherry-Trail-Z8300-4GB-64GB-ultrabook/32813027712.html"
    promotionUrl "http://s.click.aliexpress.com/deep_link.htm?dl_target_url=https%3A%2F%2Fwww.aliexpress.com%2Fitem%2F13-3-Windows-10-Laptop-notebook-computer-1920x1080-FHD-Intel-Cherry-Trail-Z8300-4GB-64GB-ultrabook%2F32813027712.html&aff_short_key=2ZR3FyF"
    imageUrl "https://ae01.alicdn.com/kf/HTB1SmCRjcnI8KJjSsziq6z8QpXaX/14-inch-Windows-10-Laptop-Ultraslim-notebook-1920x1080-FHD-Intel-Cherry-Trail-4GB-64GB-128GB-ultrabook.jpg"
    originalPrice 300
    salePrice 220
    storeName "Yepo Official Store"
    storeUrl "https://www.aliexpress.com/store/3002003"
    discount 27
    lotNum 1
    packageType "piece"
    validTime "2018-03-11"
    category_id 7
    subcategory_id 702
    thirtydaysCommission "US $5.16"
  end

  factory :category do
    id 7   
    name "Computer & Office"
    icon "fa fa-laptop"
  end

  factory :productLike do
    id 1
    user_id 1
    user_cookie_id 93510648
    product_id 11
    created_at 2018-04-10
    updated_at 2018-04-10
  end
end
