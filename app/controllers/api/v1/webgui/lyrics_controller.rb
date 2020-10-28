class Api::V1::Webgui::LyricsController < ApplicationController
  before_action :setWritter, :only => [:show]
  def show
    result = Lyric.find_by(key:params[:id]).create_default_hash
    render status: 200, json: @@renderJson.createSuccess({ :api_version => 'v1', :result => [{:result => result}] })
  end
end
