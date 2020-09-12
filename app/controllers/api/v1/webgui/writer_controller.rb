class Api::V1::Webgui::WriterController < ApplicationController
    def signin
        errorJson = RenderJson.new()
        auth = Authentication.new()
        result = auth.signin(type:"writer",email:params[:email],phrase:params[:phrase])
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
                user = Writer.create(email:params[:email],password:pass)
                ins.delete

                #支払いのカラムを作る
                Payment.create(writer_id:user.id)
                render json: JSON.pretty_generate({
                    status:'SUCCESS',
                    api_version: 'v1'
                })
            end
        else
            render json: errorJson.createError(code:'AE_0003',api_version:'v1')
        end
    end

    def home 
        auth = Authentication.new()
        errorJson = RenderJson.new()
        result = auth.isWriter?(email:params[:email],session:params[:session])

        if result[:isWriter]
            ins = ArticleRequest.joins(:writer_article_request_relations)
                    .select('article_requests.*,writer_article_request_relations.*')
                    .where("writer_article_request_relations.writer_id = ?", result[:writer].id)      
            draft = ins.where(status:1).map do |data|
                next(
                [['title',data.title],
                ['type',data.requestType],
                ['count',data.count],
                ['status',data.status],
                ['key',data.key],
                ['maxAge',data.maxAge]].to_h
                )
            end
            unaccepted = ins.where(status:2).map do |data|
                next(
                [['title',data.title],
                ['type',data.requestType],
                ['count',data.count],
                ['status',data.status],
                ['key',data.key],
                ['maxAge',data.maxAge]].to_h
                )
            end
            resubmit = ins.where(status:3).map do |data|
                next(
                [['title',data.title],
                ['type',data.requestType],
                ['count',data.count],
                ['status',data.status],
                ['key',data.key],
                ['maxAge',data.maxAge]].to_h
                )
            end
            complete = ins.where(status:4).map do |data|
                next(
                [['title',data.title],
                ['type',data.requestType],
                ['count',data.count],
                ['status',data.status],
                ['key',data.key],
                ['maxAge',data.maxAge]].to_h
                )
            end
            payment = Payment.find_by(writer_id:result[:writer].id)
            if payment
                paymentResult = {
                    unsettled:payment.unsettled,
                    confirm:payment.confirm,
                    paid:payment.paid,
                }
            end
            render json: JSON.pretty_generate({
                status:'SUCCESS',
                api_version: 'v1',
                result:{
                draft:draft,
                unaccepted:unaccepted,
                resubmit:resubmit,
                completeMonth:complete,
                complete:complete,
                payment:paymentResult
                }
            })
        else
            render json: errorJson.createError(code:'AE_0002',api_version:'v1')
        end
    end
end
