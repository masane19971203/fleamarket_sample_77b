class Product < ApplicationRecord
  

  has_many :pictures
  belongs_to :category

  accepts_nested_attributes_for :pictures, allow_destroy: true

  validates :name, :text, :price, :category_id, presence: true

  
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :size
  belongs_to_active_hash :area
  belongs_to_active_hash :postage
  belongs_to_active_hash :shipping_date

  
  
end
