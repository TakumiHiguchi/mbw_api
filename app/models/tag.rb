class Tag < ApplicationRecord
  has_many :article_tag_relations
  has_many :articles, through: :article_tag_relations

  def create_hash
    begin
      thumbnail = self.thumbnail.nil? ? Article.search(query: self.name,limit: 1).first.thumbnail.to_s : self.thumbnail.to_s
      return ({
        name: self.name,
        key: self.key,
        description: self.description,
        thumbnail: thumbnail
      })
    rescue
      return ({
        name: self.name,
        key: self.key,
        description: self.description,
        thumbnail: nil
      })
    end
  end

  def create_hash_for_article_show
    hash = self.create_hash
    #1記事も存在しなかった場合return
    if self.articles.length == 0
      hash[:related_article] = []
      return hash
    end

    article_hash = self.articles.limit(3).map do |article|
      next({
        title: article.title,
        content: article.content,
        key: article.key,
        description: article.description,
        thumbnail: article.thumbnail.to_s,
        releaseTime: article.release_time,
      })
    end
    hash[:related_article] = article_hash
    return hash
  end

  def self.createTag(article_id,tag_name)
    tagReference = self.find_by(name:tag_name)
    if !tagReference
      o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map { |i| i.to_a }.flatten
      key =(0...20).map { o[rand(o.length)] }.join
      tagReference = self.create(name:tag_name, key:key)
    end
    if !ArticleTagRelation.exists?(article_id:article_id,tag_id:tagReference.id)
      ArticleTagRelation.create(article_id:article_id,tag_id:tagReference.id)
    end
  end
end
