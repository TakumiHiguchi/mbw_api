require 'rails_helper'

RSpec.describe "Api::V1::Mbw::Articles", type: :request do
  let(:article_create){ FactoryBot.create_list(:article, 20, :with_tags) }
  let(:no_index_article_create){ FactoryBot.create_list(:article, 20, :with_tags, isindex: false) }
  let(:no_publish_article_create){ FactoryBot.create_list(:article, 20, :with_tags, release_time: Time.new.tomorrow.to_i ) }

  describe 'GET /api/v1/mbw/article' do
    it 'apiが200レスポンスを返すこと' do
      get api_v1_mbw_article_index_path
      expect(response).to have_http_status(200)
    end

    context '記事が公開されているとき' do
      it '20件の記事が取得できること' do
        article_create
        get api_v1_mbw_article_index_path
        expect(JSON.parse(response.body)["result"].length).to eq(20)
      end
    end

    context '記事がnoindexのとき' do
      it '記事が取得されないこと' do
        no_index_article_create
        get api_v1_mbw_article_index_path
        expect(JSON.parse(response.body)["result"].length).to eq(0)
      end
    end

    context '記事が非公開（投稿予定状態）のとき' do
      it '記事が取得されないこと' do
        no_publish_article_create
        get api_v1_mbw_article_index_path
        expect(JSON.parse(response.body)["result"].length).to eq(0)
      end
    end
  end

  describe 'GET /api/v1/mbw/article/:id' do
    it 'apiが200レスポンスを返すこと' do
      key = article_create.first.key
      get api_v1_mbw_article_path(id: key)
      expect(response).to have_http_status(200)
    end

    context '記事が公開されているとき' do
      before do
        @key = article_create.first.key
        get api_v1_mbw_article_path(id: key)
        @body = JSON.parse(response.body)
      end

      it '正しい記事が取得できること' do
        expect(@body["result"]["key"]).to eq(@key)
      end

      it 'タグが3件取得できること' do
        expect(@body["result"]["tags"].length).to eq(3)
      end
    end

    context '記事がnoindexのとき' do
      before do
        key = no_index_article_create.first.key
        get api_v1_mbw_article_path(id: key)
        @body = JSON.parse(response.body)
      end
      it '正しい記事が取得できること' do
        expect(@body["result"]["key"]).to eq(@key)
      end

      it 'isindexがfalseであること' do
        expect(@body["result"]["isindex"]).to eq(false)
      end

      it 'タグが3件取得できること' do
        expect(@body["result"]["tags"].length).to eq(3)
      end
    end

    context '記事が非公開（投稿予定状態）のとき' do
      it 'apiが404レスポンスを返すこと' do
        key = no_publish_article_create.first.key
        get api_v1_mbw_article_path(id: key)
        expect(response).to have_http_status(404)
      end
    end
  end
end
