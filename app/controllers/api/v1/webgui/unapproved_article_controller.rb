class Api::V1::Webgui::UnapprovedArticleController < ApplicationController
    def index
        auth = Authentication.new()
        errorJson = RenderJson.new()
        result = auth.isWriter?(email:params[:email],session:params[:session])
        if result[:isWriter]
            ins = Writer.joins(:article_requests).select("writers.*, article_requests.*").where("writers.id = ?", result[:writer].id).order("article_requests.status ASC")
            res = ins.map do |data|
                next({
                    title:data.title,
                    type:data.requestType,
                    count:data.count,
                    status:data.status,
                    key:data.key,
                    maxAge:data.maxAge
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
    def create
        auth = Authentication.new()
        errorJson = RenderJson.new()
        result = auth.isWriter?(email:params[:email],session:params[:session])
        if result[:isWriter]
            aR = ArticleRequest.find_by(key:params[:key],status:0)
            if aR
                now = Time.now.to_i
                #執筆中にする
                aR.update(status:1,maxAge:now+86400)
                #ユーザーと関連付ける
                WriterArticleRequestRelation.create(writer_id:result[:writer].id,article_request_id:aR.id)
                #記事を作成する
                UnapprovedArticle.create(
                    article_request_id:aR.id,
                    title:aR.title,
                    content:"",
                    key:params[:key],
                    description:"",
                )
                render json: JSON.pretty_generate({
                    status:'SUCCESS',
                    api_version: 'v1',
                })
            else
                render json: errorJson.createError(code:'AE_0007',api_version:'v1')
            end
        else
            render json: errorJson.createError(code:'AE_0002',api_version:'v1')
        end
    end
    def edit
        auth = Authentication.new()
        errorJson = RenderJson.new()
        result = auth.isWriter?(email:params[:email],session:params[:session])
        if result[:isWriter]
            ins = Writer.joins(article_requests: :unapproved_articles).select("writers.id, article_requests.id, article_requests.maxAge, article_requests.count,unapproved_articles.*").where("writers.id = ?", result[:writer].id).find_by("article_requests.key = ?", params[:id])
            if ins
                result ={
                    title:ins.title,
                    content:ins.content,
                    count:ins.count,
                    description:ins.description,
                    key:ins.key,
                    maxAge:ins.maxAge
                }
                render json: JSON.pretty_generate({
                    status:'SUCCESS',
                    api_version: 'v1',
                    result:result
                })
            else
                render json: errorJson.createError(code:'AE_0001',api_version:'v1')
            end
            
        else
            render json: errorJson.createError(code:'AE_0002',api_version:'v1')
        end
    end
    def update
        auth = Authentication.new()
        errorJson = RenderJson.new()
        result = auth.isWriter?(email:params[:email],session:params[:session])
        if result[:isWriter]
            ins = Writer.joins(article_requests: :unapproved_articles).select("writers.id, article_requests.id, article_requests.maxAge, article_requests.count,unapproved_articles.*").where("writers.id = ?", result[:writer].id).find_by("article_requests.key = ?", params[:id])
            if ins
                #ユーザーのデータか確認
                aR = ArticleRequest.find_by(key: params[:id])
                if aR.status == 1 || aR.status == 3
                    if params[:isSubmission] then 
                        aR.update(
                            status:2,
                            submissionTime:Time.now.to_i
                        )
                    else
                        aR.update(
                            status:1
                        )
                    end
                    
                    UnapprovedArticle.find_by(key: params[:id]).update(
                        content:params[:content]
                    )
                    render json: JSON.pretty_generate({
                        status:'SUCCESS',
                        api_version: 'v1',
                    })
                end
            else
                render json: errorJson.createError(code:'AE_0001',api_version:'v1')
            end
        else
            render json: errorJson.createError(code:'AE_0002',api_version:'v1')
        end
    end
end
