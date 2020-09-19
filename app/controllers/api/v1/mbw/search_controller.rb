class Api::V1::Mbw::SearchController < ApplicationController
    def index
        case params[:model]
            when 'lyric'
                ins = Lyric.joins(:favs).select("lyrics.*, favs.*").search(query:params[:q],limit:params[:limit])
                result = ins.map do |data|
                    next({
                        title:data.title,
                        artist:data.artist,
                        key:data.key,
                        jucket:data.jucket.to_s,
                        lyricist:data.lyricist,
                        composer:data.composer,
                        lyrics:data.lyrics,
                        amazonUrl:data.amazonUrl,
                        iTunesUrl:data.iTunesUrl,
                        fav:data.fav
                    })
                end
            when 'article'
                result = Article.search_create_hash(query:params[:q],limit:params[:limit])
        end
        render json: JSON.pretty_generate({
            status:'SUCCESS',
            api_version: 'v1',
            result:result
        })
    end
end
