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
end
