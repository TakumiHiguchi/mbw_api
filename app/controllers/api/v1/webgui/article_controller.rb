class Api::V1::Webgui::ArticleController < Api::V1::Webgui::BaseController
  before_action :setWritter
  def index
    result = @article.latest.create_article_hash({ :limit => params[:limit], :query => nil, :with_thumbnail => true, :with_tag => true })
    render status: 200, json: @@renderJson.createSuccess({ :api_version => 'v1', :result => [{:result => result}] })
  end
  def create
    auth = Authentication.new()
    errorJson = RenderJson.new()
    if auth.isAdmin?(email:params[:email],session:params[:session]) then
      user = Writer.joins(:article_requests).select('writers.*,article_requests.key').find_by('article_requests.key = ?',params[:key])
      article = Article.create(create_article_params)
      article.image_from_base64(params[:thumbnail])
      #タグを作る
      params[:tags].each do |tag_name|
        article.tags.createTag(article.id,tag_name)
      end

      uaArticle = ArticleRequest.find_by(key: params[:key])
      #支払いを更新する 
      user.payment.update(unsettled:ins.unsettled + 500)
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

  private
  def create_article_params
    return({
      title:params[:title],
      content:params[:content],
      key:params[:key],
      description:params[:description],
      release_time:params[:releaseTime],
    })
  end
end
