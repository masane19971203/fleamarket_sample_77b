class ExhibitionController < ApplicationController

  def index
    
    product = Category.find(params[:category_id])

    respond_to do |format|
      format.json{@category = product.children } 
    end

  end
end
