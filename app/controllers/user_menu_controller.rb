class UserMenuController < ApplicationController

  def index
  end

  def show
    @code = params[:id]
  end

end
