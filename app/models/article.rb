class Article < ApplicationRecord
  #アソシエーション
  mount_uploader :thumbnail, ImageUploader
  has_many :article_tag_relations
  has_many :tags, through: :article_tag_relations

  # スコープ
  scope :publish_only, -> { where(:release_time => 0..Time.new.to_i) }
  scope :index_only, -> { where(:isindex => true) }
  scope :latest, -> { order(:id => "DESC") }

  def set_key
    o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map { |i| i.to_a }.flatten
    self.key = (0...20).map { o[rand(o.length)] }.join
  end

  def create_article_hash_for_article_index
    tag_list = self.tags.map do |tag|
      tag.create_hash_for_article_index
    end
    next_articles = Article.create_article_hash({
      :query => tag_list[0][:name],
      :limit => 10,
      :with_thumbnail => true,
      :with_tag => true
    })

    return({
      title: self.title,
      content: self.content,
      key: self.key,
      description: self.description,
      thumbnail: self.thumbnail.to_s,
      releaseTime: self.release_time,
      next_articles: next_articles,
      tags: tag_list
    })
  end

  def self.create_article_hash(props)
    page = props[:page]
    page ||= 1
    case props[:search_type]
    when 'tag' 
      articles = self.search_from_tag(props)
    else
      articles = self.search(props)
    end
    result = articles.map do |article|
      hash = {
        title:article.title,
        content:article.content,
        description:article.description,
        releaseTime:article.release_time
      }
      #key
      case props[:search_type]
      when 'tag' 
        hash[:key] = article.article_key
      else
        hash[:key] = article.key
      end
      #サムネイル
      if props[:with_thumbnail]
        case props[:search_type]
        when 'tag' 
          presigned_url = Article.new.s3_presigner(path: "uploads/article/thumbnail/#{article.articles_thumbnail.to_s}")
          hash[:thumbnail] = presigned_url
        else
          hash[:thumbnail] = article.thumbnail.to_s
        end
      end
      #タグ
      if props[:with_tag]
        tag_datas = Article.joins(:tags).select('articles.id,tags.*').where('articles.id = ?',article.id)
        tags = tag_datas.map do |d|
          next({
              key:d.key,
              name:d.name
          })
        end
        hash[:tags] = tags
      end
      
      next hash
    end

    if props[:pagenation]
      pagenation = {
        current:  articles.current_page,
        previous: articles.prev_page,
        next:     articles.next_page,   
        limit_value: articles.limit_value,
        pages:    articles.total_pages,
        count:    articles.total_count
      }
      return result,pagenation
    else
      return result
    end
  end

  def self.search(props)
    page = props[:page]
    page ||= 1
    return self.page(page).per(props[:limit]) unless props[:query]
    return self.where(
      ['UPPER(title) LIKE ?', "%#{props[:query].upcase}%"]
    ).page(page).per(props[:limit])
  end

  def self.search_from_tag(props)
    page = props[:page]
    page ||= 1
    return self.page(page).per(props[:limit]) unless props[:query]
    return self.where(
      ['UPPER(tags.name) LIKE ?', "%#{props[:query].upcase}%"]
    ).page(page).per(props[:limit])
  end

  def self.search_create_hash(props)
    articles = self.search(props)
    pagenation = {
      current:  articles.current_page,
      previous: articles.prev_page,
      next:     articles.next_page,   
      limit_value: articles.limit_value,
      pages:    articles.total_pages,
      count:    articles.total_count
    }
    result = articles.map do |article|
      #タグを取得
      tag_datas = Article.joins(:tags).select('articles.id,tags.*').where('articles.id = ?',article.id)
      tags = tag_datas.map do |d|
        next({
            key:d.key,
            name:d.name
        })
      end
      next({
        title:article.title,
        content:article.content,
        key:article.key,
        description:article.description,
        thumbnail:article.thumbnail.to_s,
        releaseTime:article.release_time,
        tags:tags
      })
    end

    return result,pagenation
  end

    def image_from_base64(b64)
        uri = URI.parse(b64)
        if uri.scheme == "data" then
            data = decode(uri)
            extension = extension(uri)
            file = decode64_tempfile(data,extension)
            self.update(thumbnail:file)
        end
    end
    def decode(uri)
        opaque = uri.opaque
        data = opaque[opaque.index(",") + 1, opaque.size]
        Base64.decode64(data)
    end
    
    def extension(uri)
        opaque = uri.opaque
        mime_type = opaque[0, opaque.index(";")]
        p opaque
        case mime_type
        when "image/png" then
          ".png"
        when "image/jpeg" then
          ".jpg"
        when "image/jpg" then
          ".jpg"
        else
          raise "Unsupport Content-Type"
        end
    end
    def decode64_tempfile(f,extension)
        file = Tempfile.new(['test', extension])
        file.binmode
        file << f
        file.rewind
        return file
    end
end
