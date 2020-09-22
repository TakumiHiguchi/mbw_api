class Lyric < ApplicationRecord

    mount_uploader :jucket, ImageUploader
    has_many :favs
    def self.search(props)
      page = props[:page]
      page ||= 1
      return self.all.page(page).per(props[:limit]) unless props[:query]
      result = self.where(['UPPER(artist) LIKE ? OR UPPER(title) LIKE ?', "%#{props[:query].upcase}%", "%#{props[:query].upcase}%"]).page(page).per(props[:limit])
                
      return result
    end

  def self.search_create_hash(props)
    begin
      lyrics = self.search(props)
      result = lyrics.map do |lyric|
        next({
          title:lyric.title,
          artist:lyric.artist,
          key:lyric.key,
          jucket:lyric.jucket.to_s,
          lyricist:lyric.lyricist,
          composer:lyric.composer,
          lyrics:lyric.lyrics,
          amazonUrl:lyric.amazonUrl,
          iTunesUrl:lyric.iTunesUrl,

        })
      end
    
    end
      return result
  end
end
