class Api::V1::Mbw::LyricsController < Api::V1::Mbw::BaseController
  def show
    result = Lyric.find_by(key:params[:id]).create_default_hash
    render status: 200, json: @@renderJson.createSuccess({ :api_version => 'v1', :result => [{:result => result}] })
  end
end
