class Api::V1::Webgui::WriterController < Api::V1::Webgui::BaseController
  before_action :setWritter, :only => [:home]
  def signin
    @auth = Authentication.new()
    result = @auth.signin(:type => "writer", :email => params[:email], :phrase => params[:phrase])
    if result[:isSignin]
      render status: 200, json: @@renderJson.createSuccess({ :api_version => 'v1', :result => [{:session => result[:session]}, {:maxAge => result[:maxAge]}] })
    else
      render status: 404, json: @@renderJson.createError(code:'AE_0006',api_version:'v1')
    end
  end

  def signup
    @auth = Authentication.new()
    plan_register = PlanRegister.find_by(:key => params[:key], :session => params[:session], :email => params[:email])
    if plan_register.plan_register_check_maxage && @auth.check_passphrase(phrase: params[:phrase])
      writer = Writer.new(:email => params[:email], :password => @auth.get_SHA256_pass(phrase: params[:phrase]) )
      writer.build_payment()
      if writer.save
        plan_register.delete
        render status: 200, json: @@renderJson.createSuccess({ :api_version => 'v1', :result => []})
      else
        render status: 400, json: @@renderJson.createError(code:'AE_0003',api_version:'v1')
      end
    end
  end

  def home 
    @auth = Authentication.new()
    if @auth.isWriter?(email:params[:email],session:params[:session])
      draft, unaccepted, resubmit, complete = @user.article_requests.create_hash_for_home
      render status: 200, json: @@renderJson.createSuccess({ :api_version => 'v1', :result => [
        {:draft => draft}, {:unaccepted => unaccepted}, {:resubmit => resubmit}, {:completeMonth => complete}, {:complete => complete}, {:payment => @user.payment}
      ]})
    else
      render status: 401, json: @@renderJson.createError(code:'AE_0002',api_version:'v1')
    end
  end
end
