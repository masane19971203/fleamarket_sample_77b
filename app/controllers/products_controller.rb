class ProductsController < ApplicationController
  before_action :get_categories, only: [:index, :show]

  # 商品一覧画面の表示
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

      # 子カテゴリーの場合  
      when 1
        @children = @category.children
        @products = Product.where(category_id: @children.ids)
       
      # 孫カテゴリーの場合  
      when 2
        @products = Product.where(category_id: params[:id])
      else
        
      end
      # 画像一覧を取得
      @pictures = Picture.group(:product_id).where(product_id: @products.ids)

    # 全カテゴリーを閲覧
    else
      @view_all = true
    end
  end


  # 商品出品画面の表示
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


  # 出品した商品の出品処理
  def create
    @product = Product.new(product_params)
    @product.save!
    
    redirect_to root_path
  end


  # 商品詳細画面の表示
  def show   
    @category = Category.find(params[:category_id])
    @level = @category.depth

    # 同一カテゴリの商品及び対応する写真一覧を取得
    @products = Product.where(category_id: params[:category_id])
    @pictures = Picture.group(:product_id).where(product_id: @products.ids)
  end
  


  private 

  def get_categories
    @categories = Category.where(ancestry: nil)
  end
  
  def user_index
    @categories = Category.where(ancestry: nil)
    @products = Product.group(:product_id).where(user_id: params[:user_id])
  end

  def product_params
    params.require(:product).permit(:name, :text, :price, :brand, :status, :category_id, :size_id, :status_id, :postage_id, :area_id, :shipping_date_id, pictures_attributes: [:image]).merge(user_id: current_user.id)
  end

end
