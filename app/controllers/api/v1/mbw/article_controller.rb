class Api::V1::Mbw::ArticleController < Api::V1::Mbw::BaseController
  before_action :set_articles, :only => [:index, :show]

  def index
    result = @article.index_only.latest.create_article_hash({ :limit => params[:limit], :query => nil, :with_thumbnail => true, :with_tag => true })
    render status: 200, json: @@renderJson.createSuccess({ :api_version => 'v1', :result => [{:result => result}] })
  end

  def show
    article = @article.includes(:tags).find_by(:key => params[:id])
    result = article.create_article_hash_for_article_show if article.present?
    if result.present?
      render status: 200, json: @@renderJson.createSuccess({ :api_version => 'v1', :result => [{:result => result}] })
    else
      rescue_article_key
    end
  end

  private
  # 以下リダイレクト期間が終わったら消す
  def rescue_article_key
    response_article = @@base_worker.hit_mbw({ url: "/api/article", params: { key: params[:id] } })
    if response_article.code.to_i == 200
      res = JSON.parse(response_article.body)
      if res["type"] = 'article'
        search_article_type(res)
      else
        search_feature_type(res)
      end
    else
      render status: 404, json: @@renderJson.createError({ :status => 404, :code => 'AE_0011', :api_version => 'v1'})
    end
  end

  def search_article_type(res)
    article = @article.includes(:tags).where(
      ['UPPER(title) LIKE ?', "%#{res["title"].upcase}%"]
    ).where(
      ['UPPER(title) LIKE ?', "%#{res["artist"].upcase}%"]
    ).limit(1)
    if article.present?
      redirect_to '/api/v1/wbw/article/' + article.key, status: 301
    else
      render status: 404, json: @@renderJson.createError({ :status => 404, :code => 'AE_0011', :api_version => 'v1'})
    end
  end

  def search_feature_type(res)
    article = @article.includes(:tags).where(
      ['UPPER(title) LIKE ?', "%#{res["title"].upcase}%"]
    ).limit(1)
    if article.present?
      redirect_to '/api/v1/wbw/article/' + article.key, status: 301
    else
      render status: 404, json: @@renderJson.createError({ :status => 404, :code => 'AE_0011', :api_version => 'v1'})
    end
  end
end
