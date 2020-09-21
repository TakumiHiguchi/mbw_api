class Api::V1::Webgui::ArticleController < ApplicationController
    def index
        result = Article.search_create_hash(query: nil,limit:params[:limit])
        render json: JSON.pretty_generate({
            status:'SUCCESS',
            api_version: 'v1',
            result:result
        })
    end
    def show
        data = Article.joins(:tags).select('articles.*,tags.*,tags.key AS tag_key').where('articles.key = ?',params[:id])
        article = Article.find_by(key:params[:id])
        tag_list = data.map do |d|
            Tag.find_by(key: d.tag_key).create_hash_for_article_page(key: params[:id])
        end

        #次のおすすめ記事を返す
        next_articles = Article.search_create_hash(query: tag_list[0][:name], limit: 10)
        
        result = {
            title: article.title,
            content: article.content,
            key: article.key,
            description: article.description,
            thumbnail: article.thumbnail.to_s,
            releaseTime: article.release_time,
            next_articles: next_articles,
            tags: tag_list
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
                release_time:params[:releaseTime],
            )
            article.image_from_base64(params[:thumbnail])
            #タグを作る
            params[:tags].each do |tag_name|
                Tag.createTag(article.id,tag_name)
            end
            
        
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
