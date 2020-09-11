class CreateLyrics < ActiveRecord::Migration[6.0]
  def change
    create_table :lyrics do |t|
      t.string :key
      t.string :title
      t.string :artist
      t.string :jucket
      t.string :lyricist
      t.string :composer
      t.text :lyrics
      t.string :amazonUrl
      t.string :iTunesUrl

      t.timestamps
    end
  end
end
