class ProductsController < ApplicationController
  before_action :get_categories, only: [:index, :show]
  before_action :set_product, only: :show2
  before_action :check_user_login, only: [:new, :create, :edit, :update, :destroy]
  before_action :product_purchased, only: :update

  # 商品一覧画面の表示
  def index
    @categories = Category.where(ancestry: nil)   
    @products = Product.new
    @children = Category.new
    @level = nil

    # 特定のカテゴリのみ閲覧
    unless(params[:all_view] == 'true')
      @view_all = false
      @category = Category.find(params[:id])

      case @level = @category.depth
      # 親カテゴリーの場合    
      when 0
        @children = @category.children
        @products = Product.where(category_id: @category.indirects.ids)

      # 子カテゴリーの場合  
      when 1
        @children = @category.children
        @products = Product.where(category_id: @children.ids)
       
      # 孫カテゴリーの場合  
      when 2
        @products = Product.where(category_id: params[:id])
      else
        
      end

    # 全カテゴリーを閲覧
    else
      @view_all = true
    end
  end


  # 商品出品画面の表示
  def new
    @product = Product.new
    @product.pictures.new

    @categories = Category.where(ancestry: nil)

    @category1 = []
    @category2 = []
    @category3 = []

    # 親レコードを取得
    @categories.each do |root|
      @category1.push([root.name, root.id])
    end    
  end


  # 出品した商品の出品処理
  def create
    @product = Product.new(product_params)

    # 画像データがあるか
    if params[:product][:pictures_attributes] != nil
      if @product.save  
      else
        redirect_to action: :new
      end
    else
      redirect_to action: :new
    end

  end

  # 商品詳細画面の表示
  def show
    @product = Product.find(params[:id])
    @categories = Category.where(ancestry: nil)
    @category = Category.find(params[:category_id])
    @level = @category.depth

    # 同一カテゴリの商品を取得
    @products = Product.where(category_id: params[:category_id])
  end

  #購入確認画面の表示
  def show2
    if current_user.blank?
      redirect_to new_user_session_path
    elsif @product.user.id == current_user.id || @product.purchase == true #購入済みの場合または出品者と購入ユーザーが一致している場合
      redirect_to root_path
    else
      if @card = current_user.card #現在のユーザーがカードを登録しているなら
        Payjp.api_key = Rails.application.credentials.payjp[:secret_key]
        customer = Payjp::Customer.retrieve(@card.customer_id)
        @default_card_information = customer.cards.retrieve(@card.card_id)
        @expiration = card_expiration(@default_card_information)
      end
      if current_user.address.present? #現在のユーザーが届け先住所を登録しているなら
        @zipcode = zipcode(current_user)
        @user_address = user_address(current_user)
      end
    end
  end

  # 出品している商品の削除処理
  def destroy
    product = Product.find(params[:id])
    if product
      product.destroy
    end
    redirect_to user_menu_path(id: 101, name: 'マイページ')
  end

  def edit
    @product = Product.find(params[:id])
    @p_category = @product.category
    if current_user.blank?
      redirect_to new_user_session_path
    elsif @product.user.id != current_user.id || @product.purchase == true
      redirect_to root_path
    end
    @categories = Category.where(ancestry: nil)

    @category1 = []
    @category2 = []
    @category3 = []

    # 親レコードを取得
    @categories.each do |root|
      @category1.push([root.name, root.id])
    end
    
    if @p_category.depth == 2
      @p_category.parent.siblings.each do |child|
        @category2.push([child.name, child.id])
      end
      @p_category.siblings.each do |grandchild|
        @category3.push([grandchild.name, grandchild.id])
      end
    end
    if @p_category.depth == 1
      @p_category.siblings.each do |child|
        @category2.push([child.name, child.id])
      end
    end
    
    gon.product = @product
    gon.product_pictures = @product.pictures

    # @product.product_imagse.image_urlをバイナリーデータにしてビューで表示できるようにする
    require 'base64'
    require 'aws-sdk'

    gon.product_pictures_binary_datas = []
    if Rails.env.production?
      client = Aws::S3::Client.new(
                             region: 'ap-northeast-1',
                             access_key_id: Rails.application.credentials.aws[:aws_access_key_id],
                             secret_access_key: Rails.application.credentials.aws[:aws_secret_access_key],
                             )
      @product.pictures.each do |image|
        binary_data = client.get_object(bucket: 'f77b-furima-images', key: image.image.file.path).body.read
        gon.product_pictures_binary_datas << Base64.strict_encode64(binary_data)
      end
    else
      @product.pictures.each do |image|
        binary_data = File.read(image.image.file.file)
        gon.product_pictures_binary_datas << Base64.strict_encode64(binary_data)
      end
    end
  end

  def update
    # 登録済画像のidの配列を生成
    ids = @product.pictures.map{|image| image.id }
    # 登録済画像のうち、編集後もまだ残っている画像のidの配列を生成(文字列から数値に変換)
    exist_ids = registered_image_params[:ids].map(&:to_i)
    # 登録済画像が残っていない場合(配列に０が格納されている)、配列を空にする
    exist_ids.clear if exist_ids[0] == 0
    # 何かしらの画像があり、かつ画像以外の情報が更新成功した場合
    if (exist_ids.length != 0 || new_image_params[:pictures][0] != " ") && @product.update(update_product_params)
      # 登録済画像のうち削除ボタンをおした画像を削除
      unless ids.length == exist_ids.length
        # 削除する画像のidの配列を生成
        delete_ids = ids - exist_ids
        delete_ids.each do |id|
          @product  .pictures.find(id).destroy
        end
      end

      # 新規登録画像があればcreate
      unless new_image_params[:pictures][0] == " "
        new_image_params[:pictures].each do |image|
          @product.pictures.create(image: image, product_id: @product.id)
        end
      end
      respond_to do |format|
        format.json{ 
          @status = 0
          @id = current_user.id
        } 
      end

    # 画像がないか画像以外の情報が更新失敗した場合
    else
      respond_to do |format|
        format.json{ 
          @status = 1
          @id = @product.id
        } 
      end
    end
  end

  # ユーザーメニューの出品情報を表示
  def user_index
    @categories = Category.where(ancestry: nil)
    @products = Product.where(user_id: params[:user_id])
  end


  private 

  def get_categories
    @categories = Category.where(ancestry: nil)
  end

  def product_params  
    params.require(:product).permit(:name, :text, :price, :brand, :status, :category_id, :size_id, :status_id, :postage_id, :area_id, :shipping_date_id, pictures_attributes: [:image]).merge(user_id: current_user.id)
  end

  def zipcode(user) #郵便番号に-を入れ込む
    str = user.address.zip.to_s
    return str.insert(3, "-")
  end

  def user_address(user) #ユーザー届け先住所を連結
    return user.address.area.name + user.address.city + user.address.number + user.address.building
  end

  def card_expiration(card_info) #カード情報の有効期限をビュー表示用に変化
    exp_month = card_info.exp_month.to_s
    exp_year = card_info.exp_year.to_s.slice(2,3)
    return exp_month + " / " + exp_year
  end

  def set_product #商品情報を引っ張ってくる
    @product = Product.find(params[:id])
  end

  # ログインしているかをチェックする
  def check_user_login
    redirect_to new_user_session_path unless user_signed_in?
  end

  def update_product_params
    params.require(:product).permit(:name, :text, :price, :brand, :status, :category_id, :size_id, :status_id, :postage_id, :area_id, :shipping_date_id).merge(user_id: current_user.id)
  end

  def registered_image_params
    params.require(:registered_images_ids).permit({ids: []})
  end

  def new_image_params
    params.require(:new_images).permit({pictures: []})
  end

  def product_purchased
    @product = Product.find(params[:id])
    if @product.purchase == true
      redirect_to root_path
    end
  end
end
