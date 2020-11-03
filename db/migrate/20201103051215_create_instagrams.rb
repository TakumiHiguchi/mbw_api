class CreateInstagrams < ActiveRecord::Migration[6.0]
  def change
    create_table :instagrams do |t|
      t.string :title
      t.string :key
      t.string :url
      t.string :instagram_url
      t.text :content
      t.string :artist
      t.string :thumbnail

      t.timestamps
    end
  end
end
