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
            Tag.createTag(article.id,params[:tag1])
            Tag.createTag(article.id,params[:tag2])
            Tag.createTag(article.id,params[:tag3])
        else
            render json: errorJson.createError(code:'AE_0001',api_version:'v1')
        end
    end
end
