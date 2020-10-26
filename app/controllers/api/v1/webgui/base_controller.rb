class Api::V1::Webgui::BaseController < ApplicationController
  @@base_worker = BaseWorker.new()
  @@renderJson = RenderJson.new()

  def setWritter
    @auth = Authentication.new()
    @user = Writer.find_by(email:params[:email],session:params[:session])
    render status: 401, json: @@renderJson.createError(code:'AE_0002',api_version:'v1') if @user.nil?
  end

  def setAdminUser
    @auth = Authentication.new()
    @user = Writer.find_by(email:params[:email],session:params[:session], admin: true)
    render status: 401, json: @@renderJson.createError(code:'AE_0001',api_version:'v1') if @user.nil?
  end
end
