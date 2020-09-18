require 'rails_helper'

RSpec.describe "Api::V1::Webgui::Articles", type: :request do
  before do
    @article = Article.create(title: "test").set_key
  end

  describe 'GET /api/v1/webgui/articles' do
    it 'apiが200レスポンスを返すこと' do
      get api_v1_webgui_article_path(id:@article.key)
      expect(response).to have_http_status(200)
    end

    it 'apiがレスポンスのtitleがtestであること' do
      get api_v1_webgui_article_path(id:1)
      expect(response.body["result"]["title"]).to eq "test"
    end
  end
end
