class Api::V1::Mbw::TagController < ApplicationController
  def index
  end
  def show
    errorJson = RenderJson.new()
    tag = Tag.find_by(key: params[:id])
    if tag
      tag_hash = tag.create_hash
      tag_hash[:articles],pagenation = Article.search_create_hash(query: tag.name, limit: 20)
      tag_hash[:lyrics],pagenation = Lyric.joins(:favs).select("lyrics.*, favs.*").search_create_hash(query: tag.name, limit: 20)
      tag_hash[:recomanded] = Article.joins(:tags).select('articles.*,tags.*,tags.key AS tag_key, articles.thumbnail AS article_thumbnail').create_article_hash(search_type: 'tag', query: tag.name, limit: 10)
      render json: JSON.pretty_generate({
        status:'SUCCESS',
        api_version: 'v1',
        result: tag_hash,
        pagenation: pagenation
      })
    else
      render json: errorJson.createError(code:'AE_0101',api_version:'v1')
    end
  end
end
