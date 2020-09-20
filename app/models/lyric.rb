class Lyric < ApplicationRecord
    mount_uploader :jucket, ImageUploader
    has_many :favs
    def self.search(props)
        return self.all.limit(props[:limit]) unless props[:query]
        result = self.where(
            ['UPPER(artist) ? OR UPPER(title) LIKE ?', 
            "%#{props[:query].upcase}%", "%#{props[:query].upcase}%"]
        ).limit(props[:limit])

        
        return result
    end

  def self.search_create_hash(props)
    begin
      lyrics = self.search(props)
      result = lyrics.map do |lyric|
        next({
          title:lyrics.title,
          artist:lyrics.artist,
          key:lyrics.key,
          jucket:lyrics.jucket.to_s,
          lyricist:lyrics.lyricist,
          composer:lyrics.composer,
          lyrics:lyrics.lyrics,
          amazonUrl:lyrics.amazonUrl,
          iTunesUrl:lyrics.iTunesUrl,
        })
      end
    rescue
      result = []
    end
        return result
    end
    
end
