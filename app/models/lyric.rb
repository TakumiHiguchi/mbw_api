class Lyric < ApplicationRecord
    mount_uploader :jucket, ImageUploader
    has_many :favs
    def self.search(props)
        return self.all.limit(props[:limit]) unless props[:query]
        result = self.where(
            ['artist ? OR title LIKE ?', 
            "%#{props[:query].upcase}%", "%#{props[:query].upcase}%"]
        ).limit(props[:limit])

        
        return result
    end
    
end
