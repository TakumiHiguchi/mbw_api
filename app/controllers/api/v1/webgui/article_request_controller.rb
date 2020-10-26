class Api::V1::Webgui::ArticleRequestController < Api::V1::Webgui::BaseController
  before_action :setWritter, :only => [:can, :index, :create]
  def can
    result = ArticleRequest.where(:status => 0).map{ |data| data.create_default_hash }
    render status: 200, json: @@renderJson.createSuccess({ :api_version => 'v1', :result => [{:result => result}] })
  end

  def index
    result = ArticleRequest.all.map{ |data| data.create_default_hash }
    render status: 200, json: @@renderJson.createSuccess({ :api_version => 'v1', :result => [{:result => result}] })
  end

  def create
    ArticleRequest.create(article_request_create_params)
    render status: 200, json: @@renderJson.createSuccess({ :api_version => 'v1', :result => [] })
  end

  def edit
        auth = Authentication.new()
        errorJson = RenderJson.new()
        if auth.isAdmin?(email:params[:email],session:params[:session]) then
            data = Writer.joins(article_requests: :unapproved_articles).select("article_requests.*,unapproved_articles.*").find_by("article_requests.key = ?", params[:id])
            
            res = {
                title:data.title,
                content:data.content,
                type:data.request_type,
                status:data.status,
                count:data.count,
                description:data.description,
                key:data.key,
                maxAge:data.maxage,
                submissionTime:data.submission_time          
            }
            render json: JSON.pretty_generate({
                status:'SUCCESS',
                api_version: 'v1',
                result:res
            })
        else
            render json: errorJson.createError(code:'AE_0001',api_version:'v1')
        end
    end

    def resubmit
        auth = Authentication.new()
        errorJson = RenderJson.new()
        if auth.isAdmin?(email:params[:email],session:params[:session]) then
            #提出された記事を再提出にする
            aR = ArticleRequest.find_by(key: params[:key])
            if aR && aR.status == 2
                now = Time.now.to_i
                aR.update(
                    status:3,
                    maxage:now+86400
                )
                render json: JSON.pretty_generate({
                    status:'SUCCESS',
                    api_version: 'v1',
                })
            else
                render json: errorJson.createError(code:'AE_0001',api_version:'v1')
            end
        else
            render json: errorJson.createError(code:'AE_0001',api_version:'v1')
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
