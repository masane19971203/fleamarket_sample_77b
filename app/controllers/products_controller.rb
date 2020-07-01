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
  end

  def create
  end

  def show
    binding.pry
    @category = Category.find(params[:id])
    @level = @category.depth
  end
  
  private 

  def get_categories
    @categories = Category.where(ancestry: nil)
  end

end
