require 'rails_helper'

describe ProductsController do
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let(:product_params){attributes_for(:product_params, category_id: category.id)}
  let(:invalid_product_params){attributes_for(:product_params,text: "")}
  let(:noimage_product_params){attributes_for(:product )}
  let(:picture_params){attributes_for(:picture)}

  describe 'GET #new' do
    context 'ログイン状態になっていない' do
      it 'トップページに戻されるか' do
        get :new
        expect(response).to redirect_to(root_path)
      end   
    end

    context 'ログイン状態になってる' do
      it '出品画面に遷移できるか' do
        login user
        get :new
        expect(response.status).to eq 200
      end   
    end
  end

  describe 'POST #create' do
    context 'ログイン状態になっていない' do
      it 'トップページに戻されるか' do
        post :create, params:{product: noimage_product_params}
        expect(response).to redirect_to(root_path)
      end   
    end

    context 'ログイン状態になっている' do 
      before do
        login user
      end 
      context '妥当な値が入っている' do
        it 'テーブルにデータが保存されるか' do   
          expect do
            post :create, params:{product: product_params }
          end.to change(Product, :count).by 1
        end

        it '出品完了画面に遷移できるか' do
          login user
          get :new
          expect(response.status).to eq 200
        end   
      end

      context '妥当な値が入っていない' do
        it '入力した出品情報の内、必須項目の値が抜けているため出品画面に戻される' do
          post :create, params:{product: invalid_product_params}
          expect(response).to redirect_to(new_product_path)
        end    
        it '画像データが入力されていないため出品画面に戻される' do
          post :create, params:{product: noimage_product_params}
          expect(response).to redirect_to(new_product_path)
        end          
      end
    end
  end
  describe 'GET #edit' do
    context 'ログイン状態になっていない' do
      it 'アクセスするとログインページに飛ぶこと' do
        category = create(:category)
        product = create(:product, user_id: user.id, category_id: category.id)
        get :edit, params: { id: product.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
    context 'ログイン状態になっている' do
      before do
        login user
      end
      context '編集する商品が自分の出品した商品じゃない場合' do
        it 'rootにリダイレクトされること' do
          category = create(:category)
          user2 = create(:user)
          product = create(:product, user_id: user2.id, category_id: category.id)
          get :edit, params: {id: product.id}
          expect(response).to redirect_to(root_path)
        end
      end
      context '編集する商品が購入済みの場合' do
        it 'rootにリダイレクトされること' do
          category = create(:category)
          product = create(:product, user_id: user.id, category_id: category.id, purchase: true)
          get :edit, params: {id: product.id}
          expect(response).to redirect_to(root_path)
        end
      end
      context '編集する商品が自分の商品で、未購入の場合' do
        it '@productに正しい値が入っていること' do
          category = create(:category)
          product = create(:product, user_id: user.id, category_id: category.id)
          get :edit, params: {id: product.id}
          expect(assigns(:product)).to eq product
        end
      end
    end
  end
  describe 'PATCH #update' do
    before do
      login user
    end
    context '商品がすでに購入されている場合' do
      it 'rootにリダイレクトされること' do
        category = create(:category)
        product = create(:product, user_id: user.id, category_id: category.id, purchase: true)
        picture = create(:picture, product_id: product.id)
        picture2 = build(:picture, product_id: product.id)
        product2 = build(:product,id: product.id, user_id: user.id, purchase: true)
        patch :update, params: { id: product2.id, registered_images_ids: { ids: [ picture.id ] } }
        expect(response).to redirect_to(root_path)
      end
    end
    context '商品が正常に編集出来る場合' do
      it '@productに正常な値が入っていること' do
        category = create(:category)
        product = create(:product, user_id: user.id, category_id: category.id)
        picture = create(:picture, product_id: product.id)
        picture2 = build(:picture, product_id: product.id)
        product2 = build(:product, id: product.id, user_id: user.id)
        patch :update, params: { id: product.id, product: attributes_for(:product, category_id: category.id ), registered_images_ids: { ids: [ picture.id ], new_images: { pictures: [picture2] } } }
        expect(assigns(:product)).to eq product
      end
      it 'updateが正常に行われること' do
        category = create(:category)
        product = create(:product, user_id: user.id, category_id: category.id)
        picture = create(:picture, product_id: product.id)
        picture2 = build(:picture, product_id: product.id)
        patch :update, params: { id: product.id, product: attributes_for(:product, name: 'new', category_id: category.id ), registered_images_ids: { ids: [ picture.id ], new_images: { pictures: [picture2] } } }
        expect(product.reload.name).to eq 'new' 
      end
    end
  end
end