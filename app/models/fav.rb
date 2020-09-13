class Fav < ApplicationRecord
    belongs_to :lyric, optional: true
end
