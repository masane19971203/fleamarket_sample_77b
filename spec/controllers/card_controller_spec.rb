require 'rails_helper'

describe CardController do
  let(:user) { create(:user) }
  before do
    login user
  end
  describe '#index' do
    before do
      payjp_customer = double("Payjp::Customer")
      payjp_list = double("Payjp::ListObject")
      payjp_card = double("Payjp::Card")
      allow(Payjp::Customer).to receive(:retrieve).and_return(payjp_customer)
      allow(payjp_customer).to receive(:cards).and_return(payjp_list) 
      allow(payjp_list).to receive(:retrieve).and_return(payjp_card) 
    end
    it '@cardに正しい値が入っていること' do
      card = create(:card, user_id: user.id)
      get :index
      expect(assigns(:card)).to eq card
    end
  end
  describe '#new' do
    context "cardが登録されている場合" do
      it '@cardに正しい値が入っていること' do
        card = create(:card, user_id: user.id)
        get :new
        expect(assigns(:card)).to eq card
      end
      it 'showへのリダイレクトが行われること' do
        card = create(:card, user_id: user.id)
        get :new
        expect(response).to redirect_to(action: "show")
      end
    end
    context "cardが登録されていない場合" do
      it 'リダイレクトが行われないこと' do
        get :new
        expect(response).not_to redirect_to(action: "show")
      end
    end
  end
  describe '#create' do
    before do
      payjp_customer = double("Payjp::Customer")
      allow(Payjp::Customer).to receive(:create).and_return(payjp_customer) 
      allow(payjp_customer).to receive(:id).and_return("cus_121212121212121")
      allow(payjp_customer).to receive(:default_card).and_return("car_2323232323232323")
    end
    context 'cardが登録出来ない場合' do
      before do
        card = create(:card, user_id: user.id)
      end
      it '@cardを保存できないこと' do
        expect{ post :create, params: { payjptoken: "tok-0000000000000000" } }.to change(Card, :count).by(0)
      end
      it 'newアクションを取得する' do
        post :create, params: { payjptoken: "tok-0000000000000000" }
        expect(response).to render_template :new
      end
    end
    context 'cardが登録出来る場合' do
      it '@cardを保存すること' do
        expect{ post :create, params: { payjptoken: "tok-0000000000000000" } }.to change(Card, :count).by(1)
      end
      it 'indexにリダイレクトすること' do
        post :create, params: { payjptoken: "tok-0000000000000000" }
        expect(response).to redirect_to(action: "index")
      end
    end
  end
  describe '#destroy' do
    before do
      payjp_customer = double("Payjp::Customer")
      payjp = double("Payjp::ListObject")
      allow(Payjp::Customer).to receive(:retrieve).and_return(payjp_customer) 
      allow(payjp_customer).to receive(:delete).and_return(payjp)
    end
    it 'cardが削除されること' do
      card = create(:card, user_id: user.id)
      expect{ delete :destroy, params: { id: card.id, card_id: "" } }.to change(Card, :count).by(-1)
    end
    it 'indexにリダイレクトされること' do
      card = create(:card, user_id: user.id)
      delete :destroy, params: { id: card.id, card_id: "" }
      expect(response).to redirect_to(action: "index")
    end
  end
end