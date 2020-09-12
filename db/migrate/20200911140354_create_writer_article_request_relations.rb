class CreateWriterArticleRequestRelations < ActiveRecord::Migration[6.0]
  def change
    create_table :writer_article_request_relations do |t|
      t.integer :writer_id
      t.integer :article_request_id
      
      t.timestamps
    end
  end
end
