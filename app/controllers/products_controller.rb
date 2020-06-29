class ProductsController < ApplicationController

  def index

  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
  end

  def show
    @categories = Category.where(ancestry: nil)
  end
  
end
