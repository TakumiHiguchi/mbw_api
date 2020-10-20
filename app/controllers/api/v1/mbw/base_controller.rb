class Api::V1::Mbw::BaseController < ApplicationController
  @@renderJson = RenderJson.new

  def set_articles
    @article = Article.publish_only
  end
end