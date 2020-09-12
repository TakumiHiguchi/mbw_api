class ArticleRequest < ApplicationRecord
    has_many :unapproved_articles
    has_many :writer_article_request_relations
    has_many :writers, through: :writer_article_request_relations
end
