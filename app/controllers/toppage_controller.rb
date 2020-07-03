class ToppageController < ApplicationController
  
  def index
    @categories = Category.where(ancestry: nil)
    @products =  Product.all.order(id:"DESC").limit(4)
    @pictures = Picture.group(:product_id).where(product_id: @products.ids)
  end
  
end
