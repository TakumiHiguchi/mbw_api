class Api::V1::Webgui::ArticleController < ApplicationController
    def index
        article = Article.all
        result = article.map do |data|
            next({
                title:data.title,
                content:data.content,
                key:data.key,
                description:data.description,
                thumbnail:data.thumbnail,
                releaseTime:data.release_time
            })
        end
        render json: JSON.pretty_generate({
            status:'SUCCESS',
            api_version: 'v1',
            result:result
        })
    end
    def show
        data = Article.joins(:tags).select('articles.*,tags.*,tags.key AS tag_key').where('articles.key = ?',params[:id])
        article = Article.find_by(key:params[:id])
        tags = data.map do |d|
            next({
                key:d.tag_key,
                name:d.name
            })
        end
        result = {
            title:article.title,
            content:article.content,
            key:article.key,
            description:article.description,
            thumbnail:article.thumbnail,
            releaseTime:article.release_time,
            tags:tags
        }
        render json: JSON.pretty_generate({
            status:'SUCCESS',
            api_version: 'v1',
            result:result
        })
    end
    def create
        auth = Authentication.new()
        errorJson = RenderJson.new()
        p params[:thumbnail]
        if auth.isAdmin?(email:params[:email],session:params[:session]) then
            user = Writer.joins(:article_requests).select('writers.*,article_requests.key').find_by('article_requests.key = ?',params[:key])
            article = Article.create(
                title:params[:title],
                content:params[:content],
                key:params[:key],
                description:params[:description],
                thumbnail:params[:thumbnail],
                release_time:params[:releaseTime],
            )
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
