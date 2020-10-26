class Api::V1::Webgui::PlanRegisterController < Api::V1::Webgui::BaseController
  before_action :setAdminUser, :only => [:index]
  before_action :set_request

  def index
    if @auth.isAdmin?(email:params[:email],session:params[:session]) then
      pr = PlanRegister.within_deadline
      result = pr.map{ |data| data.create_default_hash }
      render status: 200, json: @@renderJson.createSuccess({ :api_version => 'v1', :result => [{ :result => result }] })
    else
      render status: 401, json: @@renderJson.createError(code:'AE_0001',api_version:'v1')
    end
  end

  def show
    user = PlanRegister.within_deadline.find_by(key:params[:id],session:params[:session])
    if user
      render status: 200, json: @@renderJson.createSuccess({ :api_version => 'v1', :result => [{ :result => [name:user.name,email:user.email] }] })
    else
      render status: 401, json: @@renderJson.createError(code:'AE_0014',api_version:'v1')
    end
  end

  def create
    auth = Authentication.new()
    errorJson = RenderJson.new()
    if auth.isAdmin?(email:params[:email],session:params[:session]) then
      inf = auth.getAuthInf(age:3600)
      result = PlanRegister.create(
          email:params[:userEmail],
          key:inf[:key],
          maxage:inf[:maxAge],
          session:inf[:session],
          name:params[:name]
      )
      if !result.nil?
        render json: JSON.pretty_generate({
          status:'SUCCESS',
          api_version: 'v1',
        })
      else
        render json: errorJson.createError(code:'AE_0004',api_version:'v1')
      end
    else
      render json: errorJson.createError(code:'AE_0001',api_version:'v1')
    end
  end

  def set_request
    Thread.current[:request] = request
  end
end
