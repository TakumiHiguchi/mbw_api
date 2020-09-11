class CreateUnapprovedArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :unapproved_articles do |t|
      t.integer :article_request_id
      t.string :title
      t.text :content
      t.string :key
      t.text :description
      t.string :thumbnail
      
      t.timestamps
    end
  end
end
