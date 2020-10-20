class Api::V1::Mbw::BaseController < ApplicationController
  def set_articles
    @article = Article.publish_only.index_only
  end
end