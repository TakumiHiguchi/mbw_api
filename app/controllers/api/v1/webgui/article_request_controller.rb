class Api::V1::Webgui::ArticleRequestController < ApplicationController
    def can
        auth = Authentication.new()
        errorJson = RenderJson.new()
        result = auth.isWriter?(email:params[:email],session:params[:session])

        if result[:isWriter]
            ins = ArticleRequest.where(status:0)
            res = ins.map do |data|
                next({
                    title:data.title,
                    type:data.request_type,
                    count:data.count,
                    status:data.status,
                    key:data.key
                })
            end
            render json: JSON.pretty_generate({
                status:'SUCCESS',
                api_version: 'v1',
                result:res
            })
        else
            render json: errorJson.createError(code:'AE_0002',api_version:'v1')
        end
    end

    def index
        auth = Authentication.new()
        errorJson = RenderJson.new()
        if auth.isAdmin?(email:params[:email],session:params[:session]) then
            ins = ArticleRequest.all
            result = ins.map do |data|
                next({
                    title:data.title,
                    type:data.request_type,
                    count:data.count,
                    status:data.status,
                    key:data.key,
                    maxAge:data.maxage,
                    submissionTime:data.submission_time
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

    def create
        auth = Authentication.new()
        errorJson = RenderJson.new()
        if auth.isAdmin?(email:params[:email],session:params[:session]) then
            o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map { |i| i.to_a }.flatten
            key =(0...20).map { o[rand(o.length)] }.join
            result = ArticleRequest.create(title:params[:title],request_type:params[:type],count:params[:count],key:key)
            if result
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
    def edit
        auth = Authentication.new()
        errorJson = RenderJson.new()
        if auth.isAdmin?(email:params[:email],session:params[:session]) then
            data = Writer.joins(article_requests: :unapproved_articles).select("article_requests.*,unapproved_articles.*").find_by("article_requests.key = ?", params[:id])
            
            res = {
                title:data.title,
                content:data.content,
                type:data.request_type,
                status:data.status,
                count:data.count,
                description:data.description,
                key:data.key,
                maxAge:data.maxage,
                submissionTime:data.submission_time          
            }
            render json: JSON.pretty_generate({
                status:'SUCCESS',
                api_version: 'v1',
                result:res
            })
        else
            render json: errorJson.createError(code:'AE_0001',api_version:'v1')
        end
    end

    def resubmit
        auth = Authentication.new()
        errorJson = RenderJson.new()
        if auth.isAdmin?(email:params[:email],session:params[:session]) then
            #提出された記事を再提出にする
            aR = ArticleRequest.find_by(key: params[:key])
            if aR && aR.status == 2
                now = Time.now.to_i
                aR.update(
                    status:3,
                    maxage:now+86400
                )
                render json: JSON.pretty_generate({
                    status:'SUCCESS',
                    api_version: 'v1',
                })
            else
                render json: errorJson.createError(code:'AE_0001',api_version:'v1')
            end
        else
            render json: errorJson.createError(code:'AE_0001',api_version:'v1')
        end
    end
end
