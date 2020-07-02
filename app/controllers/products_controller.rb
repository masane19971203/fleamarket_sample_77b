class ProductsController < ApplicationController

  def index

  end

  def new
    @product = Product.new
    @product.pictures.new

    @categories = Category.where(ancestry: nil)

    @category1 = []
    @category2 = []
    @category3 = []

    # 親レコードを取得
    @categories.each do |root|
      @category1.push([root.name, root.id])
    end
    
  end

  def create
    @product = Product.new(product_params)
    @product.save!
    
    redirect_to root_path
    
  end

  def show
    @categories = Category.where(ancestry: nil)
  end

  private

  def product_params
    binding.pry
    params.require(:product).permit(:name, :text, :price, :brand, :status, :category_id, :size_id, :status_id, :postage_id, :area_id, :shipping_date_id, pictures_attributes: [:images])
  end
end
