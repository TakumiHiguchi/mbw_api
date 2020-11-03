class Api::V1::Mbw::InstagramController < Api::V1::Mbw::BaseController
  def index
    render status: 200, json: @@renderJson.createSuccess({ :api_version => 'v1', :result => [{:result => Instagram.all}] })
  end

  def show
    render status: 200, json: @@renderJson.createSuccess({ :api_version => 'v1', :result => [{:result => @instagram}] })
  end

  private 
  def set_instagram_article
    @instagram = Instagram.find_by(:key => params[:id])
    render status: 404, json: @@renderJson.createError(code:'AE_0007', api_version:'v1') if @instagram.nil?
  end
end
