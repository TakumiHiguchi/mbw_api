class Api::V1::Webgui::WritterController < ApplicationController
    def signin
        errorJson = RenderJson.new()
        auth = Authentication.new()
        result = auth.signin(type:"writter",email:params[:email],phrase:params[:phrase])
        p result
        if result[:isSignin]
            render json: JSON.pretty_generate({
            status:'SUCCESS',
            api_version: 'v1',
            session:result[:session],
            maxAge:result[:maxAge]
          })
        else
            render json: errorJson.createError(code:'AE_0006',api_version:'v1')
        end
    end
    def signup
        errorJson = RenderJson.new()
        ins = PlanRegister.find_by(key:params[:key],session:params[:session],email:params[:email])
        if ins
            now = Time.now.to_i
            if ins.maxAge < now
                render json: errorJson.createError(code:'AE_0003',api_version:'v1')
            elsif !params[:phrase].match(/\A(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[\d])\w{6,12}\z/)
                render json: errorJson.createError(code:'AE_0005',api_version:'v1')
            else
                pass = Digest::SHA256.hexdigest(Digest::SHA256.hexdigest(params[:phrase] + 'music.branchwith'))
                Writter.create(email:params[:email],password:pass)
                ins.delete
                render json: JSON.pretty_generate({
                    status:'SUCCESS',
                    api_version: 'v1'
                })
            end
        else
            render json: errorJson.createError(code:'AE_0003',api_version:'v1')
        end
    end
end
