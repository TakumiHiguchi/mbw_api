class Api::V1::Webgui::ArticleController < Api::V1::Webgui::BaseController
  before_action :setWritter, :only => [:create]
  before_action :set_articles, :only => [:index]
  def index
    result = @article.latest.create_article_hash({ :limit => params[:limit], :query => nil, :with_thumbnail => true, :with_tag => true })
    render status: 200, json: @@renderJson.createSuccess({ :api_version => 'v1', :result => [{:result => result}] })
  end

  def create
    # 支払い等を処理してから記事を作成するメソッド
    user = Writer.joins(:article_requests).select('writers.*,article_requests.key').find_by('article_requests.key = ?',params[:key])
    if user.present?
      article = Article.create(create_article_params)
      article.image_from_base64(params[:thumbnail])
      # タグを作る
      params[:tags].each{|tag_name| article.tags.createTag(article.id,tag_name) }
      # 支払いを更新する 
      user.payment.update(unsettled:ins.unsettled + 500)
      # 完成済みにする
      user.article_requests.find_by(key: params[:key]).update(status:4)
      # ライターが保存する記事データベースから消す
      ua = UnapprovedArticle.find_by(article_request_id:uaArticle.id)
      ua.delete
      render status: 200, json: @@renderJson.createSuccess({ :api_version => 'v1', :result => [] })
    else
      render status: 400, json: @@renderJson.createError(code:'AE_0001',api_version:'v1')
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
