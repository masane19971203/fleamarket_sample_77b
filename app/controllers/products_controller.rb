class ProductsController < ApplicationController

  def index
    @products = Product.all
    @categories = Category.where(ancestry: nil)
  end

  def new
  end

  def create
  end

  def show
    @categories = Category.where(ancestry: nil)
  end

  def destroy
    
  end
end