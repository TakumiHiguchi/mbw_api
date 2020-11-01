class Article < ApplicationRecord
  #アソシエーション
  mount_uploader :thumbnail, ImageUploader
  has_many :article_tag_relations
  has_many :tags, through: :article_tag_relations

  # スコープ
  scope :publish_only, -> { where(:release_time => 0..Time.new.to_i) }
  scope :index_only, -> { where(:isindex => true) }
  scope :latest, -> { order(:id => "DESC") }

  def article_default_hash
    # 不要なパラメータをフロント側に送らないように設定
    return({
      title: self.title,
      content: self.content,
      key: self.key,
      isindex: self.isindex,
      description: self.description,
      thumbnail: self.thumbnail.to_s,
      releaseTime: self.release_time,
    })
  end

  def create_article_hash_for_article_show
    tag_list = self.tags.map do |tag|
      tag.create_hash_for_article_show
    end
    tag_list.length > 0 ? query = tag_list[0][:name] : query = self.title
    next_articles = Article.create_article_hash({
      :query => query,
      :limit => 10,
      :with_thumbnail => true,
      :with_tag => true
    })

    return self.article_default_hash.merge({ next_articles: next_articles }).merge({ tags: tag_list })
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
    result = articles.includes(:tags).map do |article|
      hash = {
        title:article.title,
        content:article.content,
        description:article.description,
        releaseTime:article.release_time,
        isindex: article.isindex
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
          article.thumbnail.to_s == "" ? hash[:thumbnail] = nil : hash[:thumbnail] = article.thumbnail.to_s
        end
      end
      #タグ
      if props[:with_tag]
        tags = article.tags.map do |d|
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

  def image_from_base64(b64)
    return if b64.nil?
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
