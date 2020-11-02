class Api::V1::Webgui::Admin::ArticleController < Api::V1::Webgui::Admin::BaseController
  before_action :setAdminUser, :only => [:create, :edit]
  def create
    #普通に記事を作成するメソッド
    article = Article.create(create_article_params)
    article.image_from_base64(params[:thumbnail])
    article.tags.createTag(article.id, params[:tags])
    render status: 200, json: @@renderJson.createSuccess({ :api_version => 'v1', :result => [] })
  end

  def edit
    article = Article.find_by(key: params[:id])
    if article.present?
      tag_list = article.tags.map do |tag|
        tag.create_hash_for_article_page(key: params[:id])
      end
      result = article.article_default_hash.merge({:tags => tag_list})
      render status: 200, json: @@renderJson.createSuccess({ :api_version => 'v1', :result => [{:result => result}] })
    else
      render status: 400, json: @@renderJson.createError({ :status => 400, :code => 'AE_0011', :api_version => 'v1'})
    end
  end

  private
  def create_article_params
    return({
      title:params[:title],
      content:params[:content],
      description:params[:description],
      release_time:params[:releaseTime],
      key: @@base_worker.get_key
    })
  end
end
