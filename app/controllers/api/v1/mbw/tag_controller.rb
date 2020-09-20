class Api::V1::Mbw::TagController < ApplicationController
  def index
  end
  def show
    errorJson = RenderJson.new()
    tag = Tag.find_by(key: params[:id])
    if tag
      tag_hash = tag.create_hash
      tag_hash[:articles] = Article.search_create_hash(query: tag.name, limit: 1000)
      tag_hash[:lyrics] = Lyric.joins(:favs).select("lyrics.*, favs.*").search_create_hash(query: tag.name, limit: 1000)
      render json: JSON.pretty_generate({
        status:'SUCCESS',
        api_version: 'v1',
        result: tag_hash
      })
    else
      render json: errorJson.createError(code:'AE_0101',api_version:'v1')
    end
  end
end
