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
  private

  def product_params
    params.require(:product).permit(:name, :text, :price , :brand, :status, :category_id, :size_id, :status_id, :postage_id, :area_id, :shipping_date_id, pictures_attributes: [:image])
  end
  
end
