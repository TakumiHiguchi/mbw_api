class WriterArticleRequestRelation < ApplicationRecord
    belongs_to :article_request
    belongs_to :writer
end
