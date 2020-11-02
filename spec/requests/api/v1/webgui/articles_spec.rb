require 'rails_helper'

RSpec.describe "Api::V1::Webgui::Articles", type: :request do
  let(:create_article){ FactoryBot.create(:article) }
  let(:create_writer){ FactoryBot.create(:writer, :with_article_request) }
  let(:create_admin_writer){ FactoryBot.create(:writer, :with_article_request, admin: true) }
  let(:sign_in){ Authentication.new.signin(:type => "writer", :email => create_writer.email, :phrase => "test") }
  let(:admin_sign_in){ Authentication.new.signin(:type => "writer", :email => create_admin_writer.email, :phrase => "test") }

  describe 'GET /api/v1/webgui/articles' do
    it 'apiが200レスポンスを返すこと' do
      get api_v1_webgui_article_index_path
      expect(response).to have_http_status(200)
    end

    it 'レスポンスの長さが20であること' do
      FactoryBot.create_list(:article, 20)
      get api_v1_webgui_article_index_path
      expect(JSON.parse(response.body)["result"].length).to eq(20)
    end
  end

  describe 'POST /api/v1/webgui/articles' do
    let(:params){
      {
        :title => "test",
        :content => "testtest",
        :description => "test",
        :release_time => Time.now,
        :tags => ["test"]
      }
    }
    context '管理者権限を持ったユーザーの場合' do
      before do
        params.merge!({
          :session => admin_sign_in[:session],
          :email => create_admin_writer.email,
          :key => ArticleRequest.first.key,
        })
        @params = params
      end
      it 'apiが200レスポンスを返すこと' do
        post api_v1_webgui_article_index_path(params: @params)
        expect(response).to have_http_status(200)
      end

      it 'Articleが作成されていること' do
        expect{ post api_v1_webgui_article_index_path(params: @params) }.to change(Article, :count).by(+1)
      end

      it '支払いが更新されていること' do
        post api_v1_webgui_article_index_path(params: @params)
        expect( Writer.find_by(:email => create_admin_writer.email).payment.unsettled ).to eq(500)
      end
    end

    context '一般ユーザーの場合' do
      before do
        params.merge!({
          :session => sign_in[:session],
          :email => create_writer.email,
          :key => ArticleRequest.first.key,
        })
        @params = params
      end
      it 'apiが401レスポンスを返すこと' do
        post api_v1_webgui_article_index_path(params: @params)
        expect(response).to have_http_status(401)
      end
    end

    context 'ログインしていない場合' do
      before do
        params.merge!({
          :session => "",
          :email => "test@coop.com",
          :key => ""
        })
        @params = params
      end
      it 'apiが401レスポンスを返すこと' do
        post api_v1_webgui_article_index_path(params: @params)
        expect(response).to have_http_status(401)
      end
    end
  end
end