class ProductsController < ApplicationController
  before_action :get_categories, only: [:index, :show]

  def index
    @categories = Category.where(ancestry: nil)
    
    @products = Product.new
    @children = Category.new
    @level = nil
    # 特定のカテゴリのみ閲覧
    unless(params[:all_view] == 'true')
      @view_all = false
      @category = Category.find(params[:id])

      case @level = @category.depth
      # 親カテゴリーの場合    
      when 0
        @children = @category.children
        @products = Product.where(category_id: @category.indirects.ids)

      when 1
        @children = @category.children
        @products = Product.where(category_id: @children.ids)
       
      when 2
        @products = Product.where(category_id: params[:id])
      else
        
      end

    else
      @view_all = true
    end
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
    binding.pry
    @category = Category.find(params[:id])
    @level = @category.depth
  end
  
  private 

  def get_categories
    @categories = Category.where(ancestry: nil)

  def user_index
    @categories = Category.where(ancestry: nil)
    @products = Product.where(user_id: params[:user_id])
  end
  private

  def product_params
    params.require(:product).permit(:name, :text, :price, :brand, :status, :category_id, :size_id, :status_id, :postage_id, :area_id, :shipping_date_id, pictures_attributes: [:image]).merge(user_id: current_user.id)
  end

end
