class Api::V1::Webgui::Admin::ArticleController < Api::V1::Webgui::Admin::BaseController
  def create
    #普通に記事を作成するメソッド
    auth = Authentication.new()
    errorJson = RenderJson.new()
    if auth.isAdmin?(email:params[:email],session:params[:session]) then
      article = Article.create(create_article_params)
      article.image_from_base64(params[:thumbnail])
      params[:tags].each do |tag|
        article.tags.createTag(article.id,tag_name)
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
    data = Article.find_by(key: params[:id])
    tag_list = data.tags.map do |tag|
      tag.create_hash_for_article_page(key: params[:id])
    end
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

  private
  def create_article_params
    return({
      title:params[:title],
      content:params[:content],
      description:params[:description],
      release_time:params[:releaseTime],
      key: @base_worker.get_key
    })
  end
end
