class Lyric < ApplicationRecord
  mount_uploader :jucket, ImageUploader
  has_one :fav
  def self.search(props)
    page = props[:page]
    page ||= 1
    return self.includes(:fav).order('favs.fav DESC').page(page).per(props[:limit]) unless props[:query]
    result = self.includes(:fav).where(['UPPER(artist) LIKE ? OR UPPER(title) LIKE ?', "%#{props[:query].upcase}%", "%#{props[:query].upcase}%"]).order('favs.fav DESC').page(page).per(props[:limit])
              
    return result
  end

  def create_default_hash
    self.jucket.to_s == "" ? jucket = nil : jucket = self.jucket.to_s
    return({
      title:self.title,
      artist:self.artist,
      key:self.key,
      jucket:jucket,
      lyricist:self.lyricist,
      composer:self.composer,
      lyrics:self.lyrics,
      amazonUrl:self.amazonUrl,
      iTunesUrl:self.iTunesUrl,
    })
  end

  def self.search_create_hash(props)
    lyrics = self.search(props)
    result = lyrics.includes(:fav).map do |lyric| 
      lyric.create_default_hash.merge({:favs => lyric.fav.fav}) if lyric.fav.present?
    end.compact
    if props[:with_pagenation]
      pagenation = {
        current:  lyrics.current_page,
        previous: lyrics.prev_page,
        next:     lyrics.next_page,   
        limit_value: lyrics.limit_value,
        pages:    lyrics.total_pages,
        count:    lyrics.total_count
      }
      return result,pagenation
    else
      return result
    end
  end
end
