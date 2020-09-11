class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :content
      t.string :key
      t.text :description
      t.string :thumbnail
      t.integer :releaseTime
      t.boolean :isIndex

      t.timestamps
    end
  end
end
