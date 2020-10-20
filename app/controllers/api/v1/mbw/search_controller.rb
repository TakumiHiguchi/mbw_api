class Api::V1::Mbw::SearchController < Api::V1::Mbw::BaseController
  before_action :set_articles, :only => [:index]

  def index
    case params[:model]
    when 'lyric'
      result,pagenation = Lyric.joins(:favs).select("lyrics.*, favs.*").search_create_hash(query: params[:q], limit:params[:limit], page: params[:page])
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
    render json: JSON.pretty_generate({
        status:'SUCCESS',
        api_version: 'v1',
        result:result,
        pagenation:pagenation
    })
  end
end
