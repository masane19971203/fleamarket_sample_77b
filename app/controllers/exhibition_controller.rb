class ExhibitionController < ApplicationController

  def index
    
    product = Category.find(params[:category_id])

    respond_to do |format|
      format.json{@category = product.children } 
    end
    
    # case product.depth
    # #親カテゴリの場合
    # when 0
    #   @category2 = product.child

    # # 子カテゴリの場合
    # when 1
    #   @category3 = product.child

    # else
      
    # end

  end
end
