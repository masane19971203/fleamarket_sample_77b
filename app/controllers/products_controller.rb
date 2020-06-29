class ProductsController < ApplicationController

  def index
    @products = Products.all
  end

  def new
  end

  def create
  end

  def show
    @categories = Category.where(ancestry: nil)
  end
  
end
