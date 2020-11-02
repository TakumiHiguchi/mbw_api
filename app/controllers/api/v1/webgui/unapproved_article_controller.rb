class Api::V1::Webgui::UnapprovedArticleController < Api::V1::Webgui::BaseController
  before_action :setWritter, :only => [:index, :create, :edit, :update]
  def index
    result = @user.article_requests.map{ |data| data.create_default_hash }
    render status: 200, json: @@renderJson.createSuccess({ :api_version => 'v1', :result => [{:result => result}] })
  end

  def create
    @article_request = ArticleRequest.find_by(:key => params[:key], :status => 0)
    if @article_request.present?
      @user.assign_article_request(@article_request)
      @article_request.unapproved_articles.build(unapproved_articles_create_params)
      @article_request.save
      render status: 200, json: @@renderJson.createSuccess({ :api_version => 'v1', :result => [] })
    else
      render status: 400, json: @@renderJson.createError(code:'AE_0007', api_version:'v1')
    end
  end

  def edit
    if set_user_unapproved_article
      result = @unapproved_article.create_default_hash.merge({:count => @article_request.count})
      render status: 200, json: @@renderJson.createSuccess({ :api_version => 'v1', :result => [{:result => result}] })
    else
      render status: 400, json: @@renderJson.createError(code:'AE_0001',api_version:'v1')
    end
  end

  def update
    if set_user_unapproved_article && ( @article_request.status == 1 || @article_request.status == 3 )
      @article_request.submission(params[:isSubmission])
      @unapproved_article.update(:content => params[:content])
      render status: 200, json: @@renderJson.createSuccess({ :api_version => 'v1', :result => [] })
    else
      render status: 400, json: @@renderJson.createError(code:'AE_0001',api_version:'v1')
    end
  end

  private
  def set_user_unapproved_article
    return unless set_user_article_request
    @unapproved_article = @article_request.unapproved_articles.first
    return @unapproved_article.present?
  end

  def set_user_article_request
    @article_request = @user.article_requests.find_by(:key => params[:id])
    return @article_request.present?
  end

  def unapproved_articles_create_params
    return({
      :article_request_id => @article_request.id,
      :title => @article_request.title,
      :content => "",
      :key => params[:key],
      :description => "",
    })
  end
end
