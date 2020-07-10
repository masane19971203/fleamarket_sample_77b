class UserMenuController < ApplicationController

  def show
    redirect_to new_user_session_path unless user_signed_in?
    
    @categories = Category.where(ancestry: nil)
    @code = params[:id]
    @name = params[:name]
  end

  def create
  end

end
