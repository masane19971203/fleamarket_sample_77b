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

    @categories.each do |root|
      # 親レコードを取得
      @category1.push([root.name, root.id])

      # root.children.each do |child|
      #   @category2.push([child.name, child.id])

      #   child.children.each do |g_child|
      #     @category3.push([g_child.name, g_child.id])
      #   end
      # end
    end
    

  end

  def create
    @product = Product.new(product_params)
    binding.pry
    @product.save!
    
    redirect_to root_path
    
  end

  def show
    @categories = Category.where(ancestry: nil)
  end

  private

  def product_params
    params.require(:product).permit(:name, :text, :price, :brand, :status, :category_id, :status_id, :postage_id, :area_id, :shipping_date_id, pictures_attributes: [:image])
  end
end
