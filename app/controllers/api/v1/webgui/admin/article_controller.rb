class Api::V1::Webgui::Admin::ArticleController < ApplicationController
  def create
    #普通に記事を作成するメソッド
    auth = Authentication.new()
    errorJson = RenderJson.new()
    if auth.isAdmin?(email:params[:email],session:params[:session]) then
      article = Article.create(
        title:params[:title],
        content:params[:content],
        description:params[:description],
        release_time:params[:releaseTime],
      )
      article.set_key
      article.save
      article.image_from_base64(params[:thumbnail])
      #タグを作る
      params[:tags].each do |tag_name|
        Tag.createTag(article.id,tag_name)
      end
      render json: JSON.pretty_generate({
        status:'SUCCESS',
        api_version: 'v1'
      })
    else
      render json: errorJson.createError(code:'AE_0001',api_version:'v1')
    end
  end
  def edit
    data = Article.joins(:tags).select('articles.*,tags.*,tags.key AS tag_key').where('articles.key = ?',params[:id])
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
end
