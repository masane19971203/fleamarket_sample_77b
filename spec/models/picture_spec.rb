require 'rails_helper'

RSpec.describe Picture, type: :model do
  describe '#create' do
    context 'pictureを保存できる場合' do
      it '画像が１枚あれば保存できること' do
        picture = build(:picture)

        expect(picture).to be_valid
      end
    end

    context 'pictureを保存できない場合' do
      it '画像が１枚もないと保存できること' do
        picture = build(:picture, image: nil)
        picture.valid?
        expect(picture.errors[:image]).to include("can't be blank")
      end
    end
  end
end
