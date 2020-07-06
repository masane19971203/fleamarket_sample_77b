class Address < ApplicationRecord
  validates :first_name, presence: true, format: { with: /\A[ぁ-んァ-ン一-龥]/, message: "全角ひらがな、全角カタカナ、漢字" }
  validates :last_name, presence: true, format: { with: /\A[ぁ-んァ-ン一-龥]/, message: "全角ひらがな、全角カタカナ、漢字" }
  validates :first_name_kana, presence: true, format: { with: /\A[\p{katakana} ー－&&[^ -~｡-ﾟ]]+\z/, message: "全角カタカナのみで入力して下さい" }
  validates :last_name_kana, presence: true, format: { with: /\A[\p{katakana} ー－&&[^ -~｡-ﾟ]]+\z/, message: "全角カタカナのみで入力して下さい" }
  validates :zip, presence: true, length: { is: 7 }
  validates :area_id, presence: true
  validates :user_id, presence: true
  validates :city, presence: true
  validates :number, presence: true

  belongs_to :user

  extend ActiveHash::Associations::ActiveRecordExtensions
    belongs_to_active_hash :area

end
