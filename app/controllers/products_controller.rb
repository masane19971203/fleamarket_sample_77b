class ProductsController < ApplicationController

  def index

  end

  def new
    @product = Product.new
    @product.pictures.new
  end

  def create
  end

  def show
    @categories = Category.where(ancestry: nil)
  end
  
end
