require 'rails_helper'

describe ProductsController do
  let(:user) { create(:user) }

  let(:product_params){attributes_for(:product_params)}
  let(:invalid_product_params){attributes_for(:product_params,text: "")}
  let(:noimage_product_params){attributes_for(:product )}
  let(:picture_params){attributes_for(:picture)}

  describe 'POST #create' do

    context 'ログイン状態かつ妥当な値が入っている' do
      before do
        login user
      end
      it 'テーブルにデータが保存されるか' do   
        expect do
          post :create, params:{product: product_params}
        end.to change(Product, :count).by 1
      end
    end

    context 'ログイン状態だが妥当な値が入っていない' do
      before do
        login user
      end
      it 'productテーブルに妥当な値が入っていない' do
        post :create, params:{product: invalid_product_params}
        expect(response).to redirect_to(new_product_path)
      end    
      it 'picturesテーブルが入っていない' do
        post :create, params:{product: noimage_product_params}
        expect(response).to redirect_to(new_product_path)
      end          
    end
  end
end