class Writer < ApplicationRecord

  has_many :writer_article_request_relations
  has_many :article_requests, through: :writer_article_request_relations
  has_one :payment

  def assign_article_request(article_request)
    #ユーザーと関連付ける
    WriterArticleRequestRelation.create(
      :writer_id => self.id,
      :article_request_id => article_request.id
    )
    #執筆中にする
    article_request.update(
      :status => 1,
      :maxage => Time.now.to_i + 86400
    )
  end
end
