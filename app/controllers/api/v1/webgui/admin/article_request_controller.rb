class Api::V1::Webgui::Admin::ArticleRequestController < Api::V1::Webgui::BaseController
  before_action :setAdminUser, :only => [:index, :edit, :resubmit]

  def index
    result = ArticleRequest.all.map{ |data| data.create_default_hash }
    render status: 200, json: @@renderJson.createSuccess({ :api_version => 'v1', :result => [{:result => result}] })
  end

  def edit
    article_request = @user.article_requests.find_by(:key => params[:id])
    unapproved_article = article_request.unapproved_articles.first
    if unapproved_article.present?
      result = article_request.create_default_hash.merge({
        :content => unapproved_article.content,
        :description => unapproved_article.description,
        :title => unapproved_article.title,
      })
      render status: 200, json: @@renderJson.createSuccess({ :api_version => 'v1', :result => [{:result => result}] })
    else
      render status: 400, json: @@renderJson.createError(code:'AE_0001',api_version:'v1')
    end
  end

  def resubmit
    article_request = ArticleRequest.find_by(key: params[:key])
    if article_request.present?
      article_request.resubmit
      render status: 200, json: @@renderJson.createSuccess({ :api_version => 'v1', :result => [] })
    else
      render status: 400, json: @@renderJson.createError(code:'AE_0001',api_version:'v1')
    end
  end

  def article_request_create_params
    return({
      :title => params[:title],
      :request_type => params[:type],
      :count => params[:count], 
      :key => @@base_worker.get_key
    })
  end
end
