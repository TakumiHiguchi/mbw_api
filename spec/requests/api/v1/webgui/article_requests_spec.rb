require 'rails_helper'

RSpec.describe "Api::V1::Webgui::ArticleRequests", type: :request do
  let(:create_article){ FactoryBot.create(:article) }
  let(:create_writer){ FactoryBot.create(:writer) }
  let(:sign_in){ Authentication.new.signin(:type => "writer", :email => create_writer.email, :phrase => "test") }

  describe 'GET /api/v1/webgui/article_request/can' do
    context 'サインインしている時' do
      before do
        @params = {
          :session => sign_in[:session],
          :email => create_writer.email,
        }
      end
      it 'apiが200レスポンスを返すこと' do
        get api_v1_webgui_article_request_can_path(session: @params[:session], email: @params[:email])
        expect(response).to have_http_status(200)
      end

      it 'レスポンスのArticleRequestのstatusが1であること' do
        FactoryBot.create_list(:article_request, 10, status: 0)
        FactoryBot.create_list(:article_request, 10, status: 1)
        get api_v1_webgui_article_request_can_path(session: @params[:session], email: @params[:email])

        expect(JSON.parse(response.body)["result"].length).to eq(10)
        expect(JSON.parse(response.body)["result"][0]["status"]).to eq(0)
      end
    end
    context 'サインインしていない時' do
      before do
        @params = {
          :session => "",
          :email => "",
        }
      end
      it 'apiが401レスポンスを返すこと' do
        get api_v1_webgui_article_request_can_path(session: @params[:session], email: @params[:email])
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'GET /api/v1/webgui/article_request' do
    context 'サインインしている時' do
      before do
        @params = {
          :session => sign_in[:session],
          :email => create_writer.email,
        }
      end
      it 'apiが200レスポンスを返すこと' do
        get api_v1_webgui_article_request_index_path(session: @params[:session], email: @params[:email])
        expect(response).to have_http_status(200)
      end

      it 'レスポンスのArticleRequestが20件帰ってくること' do
        FactoryBot.create_list(:article_request, 10, status: 0)
        FactoryBot.create_list(:article_request, 10, status: 1)
        get api_v1_webgui_article_request_index_path(session: @params[:session], email: @params[:email])

        expect(JSON.parse(response.body)["result"].length).to eq(20)
      end
    end
    context 'サインインしていない時' do
      before do
        @params = {
          :session => "",
          :email => "",
        }
      end
      it 'apiが401レスポンスを返すこと' do
        get api_v1_webgui_article_request_index_path(session: @params[:session], email: @params[:email])
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'POST /api/v1/webgui/article_request' do
    context 'サインインしている時' do
      before do
        @params = {
          :session => sign_in[:session],
          :email => create_writer.email,
          :title => "test",
          :type => 0,
          :count => 2001
        }
      end
      it 'apiが200レスポンスを返すこと' do
        post api_v1_webgui_article_request_index_path(params: @params)
        expect(response).to have_http_status(200)
      end

      it 'ArticleRequestが作成されること' do
        expect{ post api_v1_webgui_article_request_index_path(params: @params) }.to change(ArticleRequest, :count).by(+1)
      end
    end
    context 'サインインしていない時' do
      before do
        @params = {
          :session => "",
          :email => "",
          :title => "test",
          :type => 0,
          :count => 2001
        }
      end
      it 'apiが401レスポンスを返すこと' do
        post api_v1_webgui_article_request_index_path(params: @params)
        expect(response).to have_http_status(401)
      end
    end
  end
end