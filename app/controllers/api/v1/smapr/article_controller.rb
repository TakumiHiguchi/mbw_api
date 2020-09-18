class Api::V1::Smapr::ArticleController < ApplicationController
    def create
        auth = Authentication.new()
        errorJson = RenderJson.new()
        if auth.isAdmin?(email:params[:email],session:params[:session]) then
            user = Writer.joins(:article_requests).select('writers.*,article_requests.key').find_by('article_requests.key = ?',params[:key])
            article = Article.create(
                title: params[:title],
                content: params[:content],
                key: params[:key],
                description: params[:description],
                release_time: params[:releaseTime],
            )
            article.update_image_from_url(params[:thumbnail])
            #タグを作る
            Tag.createTag(article.id,params[:tags])
        
            uaArticle = ArticleRequest.find_by(key:params[:key])
            #支払いを更新する 
            ins = Payment.find_by(writer_id:user.id)
            ins.update(unsettled:ins.unsettled + 500)
            #ライターが保存する記事データベースから消す
            ua = UnapprovedArticle.find_by(article_request_id:uaArticle.id)
            ua.delete

            #完成済みにする
            uaArticle.update(status:4)
            render json: JSON.pretty_generate({
                status:'SUCCESS',
                api_version: 'v1'
            })
        else
            render json: errorJson.createError(code:'AE_0001',api_version:'v1')
        end
    end
end
