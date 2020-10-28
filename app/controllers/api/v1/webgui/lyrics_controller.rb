class Api::V1::Webgui::LyricsController < Api::V1::Webgui::BaseController
  before_action :setWritter, :only => [:show]
  def show
    result = Lyric.find_by(key:params[:id]).create_default_hash
    render status: 200, json: @@renderJson.createSuccess({ :api_version => 'v1', :result => [{:result => result}] })
  end
end
