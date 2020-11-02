require 'rails_helper'

RSpec.describe "Api::V1::Webgui::UnapprovedArticles", type: :request do
  let(:create_writer){ FactoryBot.create(:writer, :with_article_request) }
  let(:sign_in){ Authentication.new.signin(:type => "writer", :email => create_writer.email, :phrase => "test") }

  describe 'Get /api/v1/webgui/unapproved_article' do
    context 'サインインしている時' do
      it 'apiが200レスポンスを返すこと' do
        get api_v1_webgui_unapproved_article_index_path(:session => sign_in[:session], :email => create_writer.email)
        expect(response).to have_http_status(200)
      end

      it 'レスポンスに1件のarticle_requestが含まれていること' do
        FactoryBot.create(:article_request)
        get api_v1_webgui_unapproved_article_index_path(:session => sign_in[:session], :email => create_writer.email)
        expect(JSON.parse(response.body)["result"].length).to eq(1)
      end
    end
    context 'サインインしていない場合' do
      it 'apiが401レスポンスを返すこと' do
        post api_v1_webgui_article_index_path(:session => "", :email => "")
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'Post /api/v1/webgui/unapproved_article' do
    context 'サインインしている時' do
      context 'パラメータのarticle_requestが存在する時' do
        before do
          @params={
            :session => sign_in[:session],
            :email => create_writer.email,
            :key => FactoryBot.create(:article_request, status: 0).key
          }
        end
        it 'apiが200レスポンスを返すこと' do
          post api_v1_webgui_unapproved_article_index_path(:params => @params)
          expect(response).to have_http_status(200)
        end

        it 'UnApprovedArticleが作成されていること' do
          expect{ post api_v1_webgui_unapproved_article_index_path(:params => @params) }.to change(UnapprovedArticle, :count).by(+1)
        end
      end
      context 'パラメータのarticle_requestが存在しない時' do
        before do
          @params={
            :session => sign_in[:session],
            :email => create_writer.email,
            :key => ""
          }
        end
        it 'apiが400レスポンスを返すこと' do
          post api_v1_webgui_unapproved_article_index_path(:params => @params)
          expect(response).to have_http_status(400)
        end
      end
    end
    context 'サインインしてない時' do
      before do
        @params={
          :session => "",
          :email => ""
        }
      end
      it 'apiが401レスポンスを返すこと' do
        post api_v1_webgui_unapproved_article_index_path(:params => @params)
        expect(response).to have_http_status(401)
      end
    end
  end


end
