class ToppageController < ApplicationController
  
  def index

    @categories = Category.where(ancestry: nil)
    # binding.pry

  end
  
end
