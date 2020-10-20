class Api::V1::Mbw::TagController < ApplicationController
  def show
    tag = Tag.find_by(key: params[:id])
    if tag
      tag_hash = tag.create_hash
      tag_hash[:articles] = Article.joins(:tags).select('articles.*,tags.*,articles.key AS article_key,tags.key AS tag_key,articles.thumbnail AS articles_thumbnail').create_article_hash({ :search_type => 'tag', :query => tag.name, :limit => 20, :query => nil, :with_thumbnail => true, :with_tag => true })
      tag_hash[:lyrics] = Lyric.joins(:favs).select("lyrics.*, favs.*").search_create_hash(query: tag.name, limit: 20)
      tag_hash[:recomanded] = tag_hash[:articles]
      render json: JSON.pretty_generate({
        status:'SUCCESS',
        api_version: 'v1',
        result: tag_hash
      })
    else
      errorJson = RenderJson.new
      render json: errorJson.createError(code:'AE_0101',api_version:'v1')
    end
  end
end
