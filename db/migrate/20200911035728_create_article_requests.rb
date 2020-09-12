class CreateArticleRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :article_requests do |t|
      t.string :key
      t.string :title
      t.text :content
      t.integer :requestType, default: 0
      t.integer :status,      default: 0
      t.integer :count,       default: 2000
      t.integer :maxAge,       default: 0
      t.integer :submissionTime,       default: 0

      t.timestamps
    end
  end
end
