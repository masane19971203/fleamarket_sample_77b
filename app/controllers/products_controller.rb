class ProductsController < ApplicationController

  def index
    @products = Products.all
  end

  def new
  end

  def create
  end
end
