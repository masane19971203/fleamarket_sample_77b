class Picture < ApplicationRecord
  mount_uploader :images, ImageUploader
  # serialize :images, JSON

  belongs_to :product
end
