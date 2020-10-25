require 'rails_helper'

RSpec.describe "Api::V1::Mbw::Searches", type: :request do
  let(:article_create){ FactoryBot.create_list(:article, 20, :with_tags) }
  let(:lyric_create){ FactoryBot.create_list(:lyric, 20, :with_favs) }
  let(:no_index_article_create){ FactoryBot.create_list(:article, 20, :with_tags, isindex: false) }
  let(:no_publish_article_create){ FactoryBot.create_list(:article, 20, :with_tags, release_time: Time.new.tomorrow.to_i ) }

  describe 'GET /api/v1/mbw/search' do
    it 'apiが200レスポンスを返すこと' do
      get api_v1_mbw_search_index_path
      expect(response).to have_http_status(200)
    end

    context '検索対象が記事のとき' do
      context '記事が公開されているとき' do
        it '20件の記事が取得できること' do
          article_create
          get api_v1_mbw_search_index_path(:model => "article")
          expect(JSON.parse(response.body)["result"].length).to eq(20)
        end
      end

      context '記事がnoindexのとき' do
        it '20件の記事が取得できること' do
          no_index_article_create
          get api_v1_mbw_search_index_path(:model => "article")
          expect(JSON.parse(response.body)["result"].length).to eq(20)
        end
      end

      context '記事が非公開（投稿予定状態）のとき' do
        it '記事が取得されないこと' do
          no_publish_article_create
          get api_v1_mbw_search_index_path(:model => "article")
          expect(JSON.parse(response.body)["result"].length).to eq(0)
        end
      end
    end

    context '検索対象が歌詞のとき' do
      it '20件の歌詞が取得できること' do
        lyric_create
        get api_v1_mbw_search_index_path(:model => "lyric")
        expect(JSON.parse(response.body)["result"].length).to eq(20)
      end
    end
  end
end
