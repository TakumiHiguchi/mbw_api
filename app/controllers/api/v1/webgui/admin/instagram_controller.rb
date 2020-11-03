class Api::V1::Mbw::InstagramController < Api::V1::Mbw::BaseController
  before_action :setAdminUser, :only => [:create]
  def create
    Instagram.create(create_params)
    render status: 200, json: @@renderJson.createSuccess({ :api_version => 'v1', :result => [{:result => Instagram.all}] })
  end

  private 
  def set_instagram_article
    @instagram = Instagram.find_by(:key => params[:id])
    render status: 404, json: @@renderJson.createError(code:'AE_0007', api_version:'v1') if @instagram.nil?
  end

  def create_params
    return({
      :title => params[:title],
      :key => params[:key],
      :url => params[:url],
      :instagram_url => params[:instagram_url],
      :content => params[:content],
      :artist => params[:artist],
      :thumbnail => params[:thumbnail],
    })
  end
end
