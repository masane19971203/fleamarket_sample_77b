class UserMenuController < ApplicationController

  def index
  end

  def show
    @code = params[:id]
    @name = params[:name]
  end

end
