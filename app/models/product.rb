class Product < ApplicationRecord
  has_many :pictures
  accepts_nested_attributes_for :pictures, allow_destroy: true
  validates :name, :text, :price, :category, presence: true
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :size
  belongs_to_active_hash :area
  belongs_to_active_hash :category
  belongs_to_active_hash :postage
  belongs_to_active_hash :shipping_date
  
end
