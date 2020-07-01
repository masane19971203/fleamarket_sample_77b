class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(user_params)
    if @user.save
      redirect_to root_path
    else
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:nickname, :comment).merge(without_validate: true)
  end
  def ensure_correct_user
    if current_user.id != params[:id].to_i
      redirect_to root_path
    end
  end
end

