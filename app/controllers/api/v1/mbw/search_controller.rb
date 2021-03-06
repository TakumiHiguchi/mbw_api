class Api::V1::Mbw::SearchController < Api::V1::Mbw::BaseController
  before_action :set_articles, :only => [:index]

  def index
    case params[:model]
    when 'lyric'
      result,pagenation = Lyric.search_create_hash(query: params[:q], limit:params[:limit], page: params[:page], with_pagenation: true)
    when 'article'
      result,pagenation = @article.latest.create_article_hash({
        :limit => params[:limit],
        :query => params[:q],
        :page => params[:page],
        :pagenation => true,
        :with_thumbnail => true,
        :with_tag => true
      })
    end
    render status: 200, json: @@renderJson.createSuccess({ :api_version => 'v1', :result => [{:result => result}, {:pagenation => pagenation}] })
  end
end
