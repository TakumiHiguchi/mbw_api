class Api::V1::Webgui::BaseController < ApplicationController
  @@base_worker = BaseWorker.new()
  @@renderJson = RenderJson.new()
  @auth = Authentication.new()

  def setWritter
    @user = Writer.find_by(email:params[:email],session:params[:session])
  end
end
