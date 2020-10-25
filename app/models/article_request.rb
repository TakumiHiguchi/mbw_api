class ArticleRequest < ApplicationRecord
  has_many :unapproved_articles
  has_many :writer_article_request_relations
  has_many :writers, through: :writer_article_request_relations

  def create_default_hash
    return({
      :title => self.title,
      :type => self.tipe,
      :count => self.count,
      :status => self.status,
      :key => self.key,
      :maxAge => self.maxage
    })
  end
  def self.create_hash_for_home
    draft = self.where(status:1).map{ |data| data.create_default_hash }
    unaccepted = self.where(status:2).map{ |data| data.create_default_hash }
    resubmit = self.where(status:3).map{ |data| data.create_default_hash }
    complete = self.where(status:4).map{ |data| data.create_default_hash }
    return draft, unaccepted, resubmit, complete
  end
end
