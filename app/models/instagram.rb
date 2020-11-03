class Instagram < ApplicationRecord
  mount_uploader :thumbnail, ImageUploader
end
