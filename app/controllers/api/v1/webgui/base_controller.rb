class Api::V1::Webgui::BaseController < ApplicationController
  @@base_worker = BaseWorker.new()
  @@renderJson = RenderJson.new()

  def setWritter
    @auth = Authentication.new()
    @user = Writer.find_by(email:params[:email],session:params[:session])
  end

  def setAdminUser
    @auth = Authentication.new()
    @user = Writer.find_by(email:params[:email],session:params[:session], admin: true)
  end
end
