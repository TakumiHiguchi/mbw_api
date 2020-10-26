class Api::V1::Webgui::PlanRegisterController < Api::V1::Webgui::BaseController

  def show
    user = PlanRegister.within_deadline.find_by(key:params[:id],session:params[:session])
    if user
      render status: 200, json: @@renderJson.createSuccess({ :api_version => 'v1', :result => [{ :result => [name:user.name,email:user.email] }] })
    else
      render status: 401, json: @@renderJson.createError(code:'AE_0014',api_version:'v1')
    end
  end
end
