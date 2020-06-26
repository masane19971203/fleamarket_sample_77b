class Area < ApplicationRecord

  # データの参照先をDBからprefectureモデルへ変更
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture  
  
end
