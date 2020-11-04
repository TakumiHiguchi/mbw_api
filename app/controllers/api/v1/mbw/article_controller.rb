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
      render status: 404, json: @@renderJson.createError({ :status => 404, :code => 'AE_0011', :api_version => 'v1'})
    end
  end
end
