class Api::V1::Webgui::LyricsController < ApplicationController
    def show
        lyrics = Lyric.find_by(key:params[:id])
        result = {
            title:lyrics.title,
            artist:lyrics.artist,
            key:lyrics.key,
            jucket:lyrics.jucket.to_s,
            lyricist:lyrics.lyricist,
            composer:lyrics.composer,
            lyrics:lyrics.lyrics,
            amazonUrl:lyrics.amazonUrl,
            iTunesUrl:lyrics.iTunesUrl,
        }
        render json: JSON.pretty_generate({
            status:'SUCCESS',
            api_version: 'v1',
            result:result
        })
    end
end
