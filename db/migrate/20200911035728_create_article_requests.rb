class CreateArticleRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :article_requests do |t|
      t.string :key
      t.string :title
      t.text :content
      t.integer :request_type, default: 0
      t.integer :status,      default: 0
      t.integer :count,       default: 2000
      t.integer :maxage,       default: 0
      t.integer :submission_time,       default: 0

      t.timestamps
    end
  end
end
