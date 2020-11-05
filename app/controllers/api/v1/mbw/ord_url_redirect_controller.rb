class Api::V1::Mbw::OrdUrlRedirectController < Api::V1::Mbw::BaseController
  # 旧式サイトから301リダイレクトするためのコントローラー
  # あとで消す
  before_action :set_articles
  def article
    rescue_article_key
  end

  private
  # 以下リダイレクト期間が終わったら消す
  def rescue_article_key
    response_article = @@base_worker.hit_mbw({ url: "/api/article", params: { key: params[:key] } })
    if response_article.code.to_i == 200
      res = JSON.parse(response_article.body)
      if res["type"] == "article"
        search_article_type(res)
      elsif res["type"] == "lyrics"
        search_lyrics_type(res)
      else
        search_feature_type(res)
      end
    else
      render status: 404, json: @@renderJson.createError({ :status => 404, :code => 'AE_0011', :api_version => 'v1'})
    end
  end

  def search_article_type(res)
    article = @article.where(
      ["REPLACE(REPLACE(title,' ',''),'　','') LIKE ?", "%#{res["title"].gsub(" ", "")}%"]
    ).where(
      ["REPLACE(REPLACE(title,' ',''),'　','') LIKE ?", "%#{res["artist"].gsub(" ", "")}%"]
    )
    if article.present?
      if article.length > 1
        article = highly_relevant(article, res)
      else
        article = article.first
      end
      render status: 301, json: @@renderJson.createSuccess({ :api_version => 'v1', :result => [{:key => article.key, :type => "article"}] })
    else
      render status: 404, json: @@renderJson.createError({ :status => 404, :code => 'AE_0011', :api_version => 'v1'})
    end
  end

  def highly_relevant(articles, res)
    return if articles.nil?
    result = nil
    articles.includes(:tags).each do |article|
      result = article if article.tags.first.name == res["artist"] && article.tags.second.name == res["title"]
      result = article if article.tags.first.name == res["title"] && article.tags.second.name == res["artist"]
    end
    result ||= articles.first
    return result
  end

  def search_feature_type(res)
    article = @article.find_by(
      ["REPLACE(REPLACE(title,' ',''),'　','') LIKE ?", "%#{res["title"].gsub(" ", "")}%"]
    )
    if article.present?
      render status: 301, json: @@renderJson.createSuccess({ :api_version => 'v1', :result => [{:key => article.key, :type => "article"}] })
    else
      render status: 404, json: @@renderJson.createError({ :status => 404, :code => 'AE_0011', :api_version => 'v1'})
    end
  end

  def search_lyrics_type(res)
    article = Lyric.where(
      ["REPLACE(REPLACE(title,' ',''),'　','') LIKE ?", "%#{res["title"].gsub(" ", "")}%"]
    ).find_by(
      ["REPLACE(REPLACE(artist,' ',''),'　','') LIKE ?", "%#{res["artist"].gsub(" ", "")}%"]
    )
    if article.present?
      render status: 301, json: @@renderJson.createSuccess({ :api_version => 'v1', :result => [{:key => article.key, :type => "lyrics"}] })
    else
      render status: 404, json: @@renderJson.createError({ :status => 404, :code => 'AE_0011', :api_version => 'v1'})
    end
  end
end