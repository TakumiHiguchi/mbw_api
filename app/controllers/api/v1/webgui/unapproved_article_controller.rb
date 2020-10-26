class Api::V1::Webgui::UnapprovedArticleController < Api::V1::Webgui::BaseController
  before_action :setWritter, :only => [:index, :create]
  def index
    result = @user.article_requests.map{ |data| data.create_default_hash }
    render status: 200, json: @@renderJson.createSuccess({ :api_version => 'v1', :result => [{:result => result}] })
  end

  def create
    @article_request = ArticleRequest.find_by(:key => params[:key], :status => 0)
    if @article_request.present?
      @user.assign_article_request(@article_request)
      @article_request.unapproved_articles.build(unapproved_articles_create_params)
      article_request.save
      render status: 200, json: @@renderJson.createSuccess({ :api_version => 'v1', :result => [] })
    else
      render json: @@renderJson.createError(code:'AE_0007',api_version:'v1')
    end
  end
    def edit
        auth = Authentication.new()
        errorJson = RenderJson.new()
        result = auth.isWriter?(email:params[:email],session:params[:session])
        if result[:isWriter]
            ins = Writer.joins(article_requests: :unapproved_articles).select("writers.id, article_requests.id,article_requests.maxage, article_requests.count,unapproved_articles.*").where("writers.id = ?", result[:writer].id).find_by("article_requests.key = ?", params[:id])
            if ins
                result ={
                    title:ins.title,
                    content:ins.content,
                    count:ins.count,
                    description:ins.description,
                    key:ins.key,
                    maxAge:ins.maxage
                }
                render json: JSON.pretty_generate({
                    status:'SUCCESS',
                    api_version: 'v1',
                    result:result
                })
            else
                render json: errorJson.createError(code:'AE_0001',api_version:'v1')
            end
            
        else
            render json: errorJson.createError(code:'AE_0002',api_version:'v1')
        end
    end
    def update
        auth = Authentication.new()
        errorJson = RenderJson.new()
        result = auth.isWriter?(email:params[:email],session:params[:session])
        if result[:isWriter]
            ins = Writer.joins(article_requests: :unapproved_articles).select("writers.id, article_requests.id, article_requests.maxage, article_requests.count,unapproved_articles.*").where("writers.id = ?", result[:writer].id).find_by("article_requests.key = ?", params[:id])
            if ins
                #ユーザーのデータか確認
                aR = ArticleRequest.find_by(key: params[:id])
                if aR.status == 1 || aR.status == 3
                    if params[:isSubmission] then 
                        aR.update(
                            status:2,
                            submission_time:Time.now.to_i
                        )
                    else
                        aR.update(
                            status:1
                        )
                    end
                    
                    UnapprovedArticle.find_by(key: params[:id]).update(
                        content:params[:content]
                    )
                    render json: JSON.pretty_generate({
                        status:'SUCCESS',
                        api_version: 'v1',
                    })
                end
            else
                render json: errorJson.createError(code:'AE_0001',api_version:'v1')
            end
        else
            render json: errorJson.createError(code:'AE_0002',api_version:'v1')
        end
    end
  private
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
