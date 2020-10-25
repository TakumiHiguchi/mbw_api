class Writer < ApplicationRecord

  has_many :writer_article_request_relations
  has_many :article_requests, through: :writer_article_request_relations
  has_one :payment
end
