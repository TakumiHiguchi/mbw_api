class Api::V1::Webgui::PlanRegisterController < ApplicationController
  def index
    auth = Authentication.new()
    errorJson = RenderJson.new()
    if auth.isAdmin?(email:params[:email],session:params[:session]) then
      now = Time.now.to_i
      ins = PlanRegister.where(maxAge: now..Float::INFINITY)
      result = ins.map do |data|
        return({
            name:data.name,
            email:data.email,
            maxAge:data.maxAge,
            url:Root + "/signup?k="+data.key+"&s="+data.session
        })
      end
      render json: JSON.pretty_generate({
        status:'SUCCESS',
        api_version: 'v1',
        result:result
      })
    else
      render json: errorJson.createError(code:'AE_0001',api_version:'v1')
    end
  end

  def show
    errorJson = RenderJson.new()
    user = PlanRegister.find_by(key:params[:id],session:params[:session])
    if user
      now = Time.now.to_i
      if user.maxAge > now
        ins = [name:user.name,email:user.email]
        
        render json: JSON.pretty_generate({
          status:'SUCCESS',
          api_version: 'v1',
          result:ins
        })
      else
        render json: errorJson.createError(code:'AE_0001',api_version:'v1')
      end
    else
      render json: errorJson.createError(code:'AE_0014',api_version:'v1')
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
          maxAge:inf[:maxAge],
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
end
