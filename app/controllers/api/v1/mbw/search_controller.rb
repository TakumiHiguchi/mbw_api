class Api::V1::Mbw::SearchController < ApplicationController
    def index
        case params[:model]
            when 'lyric'
                result,pagenation = Lyric.joins(:favs).select("lyrics.*, favs.*").search_create_hash(query: params[:q], limit:params[:limit], page: params[:page])
                
            when 'article'
                result = Article.search_create_hash(query:params[:q],limit:params[:limit])
        end
        render json: JSON.pretty_generate({
            status:'SUCCESS',
            api_version: 'v1',
            result:result,
            pagenation:pagenation
        })
    end
end
