class ProductsController < ApplicationController
  before_action :get_categories, only: [:index, :show]

  def index

    # @category = Category.find(params[:id])
    # @products = Product.new
    # @children = Category.new

    # # 親カテゴリーの場合
    # if(@category.ancestry == nil)
    #   @children = @category.children

    #   @children.each do |child|
    #     child.children.each do |g_child|
    #       @products << Product.where(category_id: g_child.id)
    #     end
    #   end
    # else
    #   # 子カテゴリーの場合
    #   if(@category.ancestry.to_i >= 1)
    #     children = @category.children
    #     @children = children.children

    #     children.each do |child|
    #       @products << Product.where(category_id: child.id)
    #     end

    #   # 孫カテゴリー選択の場合
    #   else
    #     @products = Product.where(category_id: params[:id])
    #   end
    # end 

  end

  def new
  end

  def create
  end

  def show
   
  end
  
  private 

  def get_categories
    @categories = Category.where(ancestry: nil)
  end

end
