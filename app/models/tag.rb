class Tag < ApplicationRecord
  has_many :article_tag_relations
  has_many :articles, through: :article_tag_relations

  def self.createTag(article_id,tag_name)
    tagReference = self.find_by(name:tag_name)
    if !tagReference
      o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map { |i| i.to_a }.flatten
      key =(0...20).map { o[rand(o.length)] }.join
      tagReference = self.create(name:tag,key:key)
    end
    ArticleTagRelation.create(article_id:article_id,tag_id:tagReference.id)
  end
end
