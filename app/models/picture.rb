class Picture < ApplicationRecord
  mount_uploader :images, ImageUploader

  belongs_to :product
end
