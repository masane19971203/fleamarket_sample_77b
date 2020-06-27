class AddressesController < ApplicationController
  def new
    @user = User.find(current_user.id)
    if @address = Address.find_by(user_id: current_user.id)
    else
      @address = Address.new
    end
  end

  def create
    if Address.create(address_params)
      redirect_to root_path
    else
      render 'address#new'
    end
  end

  def update
    if Address.update(address_params)
      redirect_to root_path
    else
      render 'address#new'
    end
  end

  private
  def address_params
    params.require(:address).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :zip, :area_id, :city, :number, :building, :phonenumber).merge(user_id: current_user.id)
  end
end
