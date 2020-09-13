class CreateFavs < ActiveRecord::Migration[6.0]
  def change
    create_table :favs do |t|
      t.integer :lyric_id
      t.integer :fav
      
      t.timestamps
    end
  end
end
