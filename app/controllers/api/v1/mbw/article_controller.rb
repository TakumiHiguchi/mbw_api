class Api::V1::Mbw::ArticleController < Api::V1::Mbw::BaseController
  before_action :set_articles, :only => [:index, :show]

  def index
    result = @article.latest.create_article_hash({ :query => nil, :with_thumbnail => true, :with_tag => true })
    render status: 200, json: JSON.pretty_generate({
      status: 200,
      api_version: 'v1',
      result:result
    })
  end
  def show
    article = @article.includes(:tags).find_by(:key => params[:id])
    result = article.create_article_hash_for_article_index if article.present?

    if result.present?
      render status: 200, json: JSON.pretty_generate({
        :status => 200,
        :api_version => 'v1',
        :result => result
      })
    else
      json = RenderJson.new
      render status: 404, json: json.createError({ :status => 404, :code => 'AE_0011', :api_version => 'v1'})
    end
  end
end
