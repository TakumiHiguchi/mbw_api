class Api::V1::Webgui::SearchController < ApplicationController
    def index
        case params[:model]
            when 'lyric'
                result = Lyric.search(query:params[:q],limit:params[:limit])
            when 'article'
                result = Lyric.search(query:params[:q],limit:params[:limit])
        end
        render json: JSON.pretty_generate({
            status:'SUCCESS',
            api_version: 'v1',
            result:result
        })
    end
end
