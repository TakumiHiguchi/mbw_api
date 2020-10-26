class Api::V1::Webgui::Admin::PlanRegisterController < Api::V1::Webgui::BaseController
  before_action :setAdminUser, :only => [:index, :create]
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

  def create
    if @auth.isAdmin?(email:params[:email],session:params[:session]) then
      result = PlanRegister.create( plan_register_create_params )
      render status: 200, json: @@renderJson.createSuccess({ :api_version => 'v1', :result => [] })
    else
      render status: 401, json: @@errorJson.createError(code:'AE_0001',api_version:'v1')
    end
  end

  def set_request
    Thread.current[:request] = request
  end

  private
  def plan_register_create_params
    inf = @auth.getAuthInf(age:3600)
    return({
      email:params[:userEmail],
      key:inf[:key],
      maxage:inf[:maxAge],
      session:inf[:session],
      name:params[:name]
    })
  end
end
