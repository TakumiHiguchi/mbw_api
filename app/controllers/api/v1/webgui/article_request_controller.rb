class Api::V1::Webgui::ArticleRequestController < Api::V1::Webgui::BaseController
  before_action :setWritter, :only => [:can, :index, :create]
  def can
    result = ArticleRequest.where(:status => 0).map{ |data| data.create_default_hash }
    render status: 200, json: @@renderJson.createSuccess({ :api_version => 'v1', :result => [{:result => result}] })
  end

  def create
    ArticleRequest.create(article_request_create_params)
    render status: 200, json: @@renderJson.createSuccess({ :api_version => 'v1', :result => [] })
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
