class AddressesController < ApplicationController
  before_action :ensure_correct_user, only: [:new, :create, :update]

  def new
    @user = User.find(params[:user_id])
    if @address = Address.find_by(user_id: @user.id)
    else
      @address = Address.new
    end
  end

  def create
    @user = User.find(params[:user_id])
    @address = Address.new(address_params)
    if @address.save
      redirect_to root_path
    else
      render :new
    end
  end

  def update
    @user = User.find(params[:user_id])
    @address = Address.find(params[:id])
    if @address.update(address_params)
      redirect_to root_path
    else
      render :new
    end
  end

  private
  def address_params
    params.require(:address).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :zip, :area_id, :city, :number, :building, :phonenumber).merge(user_id: @user.id)
  end

  def ensure_correct_user
    if current_user.id != params[:user_id].to_i
      redirect_to root_path
    end
  end
end
