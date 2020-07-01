class Picture < ApplicationRecord
  serialize :images, ActiveRecord::Type::Json.new

  mount_uploaders :images, ImageUploader
  belongs_to :product
end
