class Api::V1::Mbw::ArticleController < Api::V1::Mbw::BaseController
  before_action :set_articles, :only => [:index, :show]

  def index
    result, pagenation = @article.latest.create_article_hash({ :query => nil, :with_thumbnail => true, :with_tag => true })
    render json: JSON.pretty_generate({
      status:'SUCCESS',
      api_version: 'v1',
      result:result,
      pagenation: pagenation
    })
  end
  def show
      data = Article.joins(:tags).select('articles.*,tags.*,tags.key AS tag_key, articles.thumbnail AS article_thumbnail').where('articles.key = ?',params[:id])
      article = @article.find_by(:key => params[:id])
      tag_list = data.map do |d|
          Tag.find_by(key: d.tag_key).create_hash_for_article_page(key: params[:id])
      end
  
      #次のおすすめ記事を返す
      next_articles,pagenation = Article.search_create_hash(query: tag_list[0][:name], limit: 10)
      
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
end
