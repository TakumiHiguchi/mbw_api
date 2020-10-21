require 'rails_helper'

RSpec.describe "Api::V1::Mbw::Searches", type: :request do
  let(:article_create){ FactoryBot.create_list(:article, 20, :with_tags) }
  let(:lyric_create){ FactoryBot.create_list(:lyric, 20, :with_favs) }
  let(:no_index_article_create){ FactoryBot.create_list(:article, 20, :with_tags, isindex: false) }
  let(:no_publish_article_create){ FactoryBot.create_list(:article, 20, :with_tags, release_time: Time.new.tomorrow.to_i ) }

  describe 'GET /api/v1/mbw/tag/:id' do
    context 'タグが存在するとき' do
      it 'apiが200レスポンスを返すこと' do
        key = article_create.first.tags.first.key
        get api_v1_mbw_tag_path(:id => key)
        expect(response).to have_http_status(200)
      end

      it '正しいタグが帰っていること' do
        key = article_create.first.tags.first.key
        name = article_create.first.tags.first.name
        get api_v1_mbw_tag_path(:id => key)
        expect(JSON.parse(response.body)["result"]["name"]).to eq(name)
      end
    end

    context 'タグが存在しないとき' do
      it 'apiが404レスポンスを返すこと' do
        get api_v1_mbw_tag_path(:id => "test")
        expect(response).to have_http_status(404)
      end
    end
  end
end
