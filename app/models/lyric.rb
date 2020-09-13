class Lyric < ApplicationRecord
    mount_uploader :jucket, ImageUploader
    has_many :favs
end
