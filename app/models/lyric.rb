class Lyric < ApplicationRecord
    mount_uploader :jucket, ImageUploader
    has_many :favs
    def self.search(props)
        return self.all.limit(props[:limit]) unless props[:query]
        ins = self.where(
            ['artist ? OR title LIKE ?', 
            "%#{props[:query].upcase}%", "%#{props[:query].upcase}%"]
        ).limit(props[:limit])

        result = ins.map do |data|
            next({
                title:data.title,
                artist:data.artist,
                key:data.key,
                jucket:data.jucket.to_s,
                lyricist:data.lyricist,
                composer:data.composer,
                lyrics:data.lyrics,
                amazonUrl:data.amazonUrl,
                iTunesUrl:data.iTunesUrl,
            })
        end
        return result
    end
    
end
