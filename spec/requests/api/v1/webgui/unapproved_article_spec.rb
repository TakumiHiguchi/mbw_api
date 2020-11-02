require 'rails_helper'

RSpec.describe "Api::V1::Webgui::UnapprovedArticles", type: :request do
  let(:create_writer){ FactoryBot.create(:writer, :with_article_request) }
  let(:create_writer_with_unapproved_article){ FactoryBot.create(:writer, :with_article_request_and_unapproved_article) }
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

  describe 'GET /api/v1/webgui/unapproved_article/:id/edit' do
    let(:sign_in){ Authentication.new.signin(:type => "writer", :email => create_writer_with_unapproved_article.email, :phrase => "test") }
    context 'サインインしている時' do
      context 'パラメータのarticle_requestが存在する時' do
        it 'apiが200レスポンスを返すこと' do
          get edit_api_v1_webgui_unapproved_article_path(
            :id => create_writer_with_unapproved_article.article_requests.first.key, 
            :session => sign_in[:session], 
            :email => create_writer_with_unapproved_article.email
          )
          expect(response).to have_http_status(200)
        end

        it 'レスポンスにunapproved_articleが含まれていること' do
          @article_request = create_writer_with_unapproved_article.article_requests.first
          get edit_api_v1_webgui_unapproved_article_path(
            :id => @article_request.key, 
            :session => sign_in[:session], 
            :email => create_writer_with_unapproved_article.email
          )
          expect(JSON.parse(response.body)["result"]["title"]).to eq(@article_request.unapproved_articles.first.title)
        end
      end
      context 'パラメータのarticle_requestが存在しない時' do
        it 'apiが400レスポンスを返すこと' do
          get edit_api_v1_webgui_unapproved_article_path(
            :id => "test", 
            :session => sign_in[:session], 
            :email => create_writer_with_unapproved_article.email
          )
          expect(response).to have_http_status(400)
        end
      end
    end
    context 'サインインしてない時' do
      it 'apiが401レスポンスを返すこと' do
        get edit_api_v1_webgui_unapproved_article_path(:id => "test", :session => "", :email => "")
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'PUT /api/v1/webgui/unapproved_article/:id' do
    let(:sign_in){ Authentication.new.signin(:type => "writer", :email => create_writer_with_unapproved_article.email, :phrase => "test") }
    context 'サインインしている時' do
      context 'パラメータのarticle_requestが存在する時' do
        before do
          @article_request = create_writer_with_unapproved_article.article_requests.first
          @params = {
            :id => @article_request.key, 
            :session => sign_in[:session], 
            :email => create_writer_with_unapproved_article.email,
            :content => "test",
            :isSubmission => true
          }
        end
        it 'apiが200レスポンスを返すこと' do
          put api_v1_webgui_unapproved_article_path( @params )
          expect(response).to have_http_status(200)
        end

        it 'unapproved_articleのcontentが変わっていること' do
          put api_v1_webgui_unapproved_article_path( @params )
          expect(@article_request.unapproved_articles.first.content).to eq("test")
        end

        context 'isSubmissionがtrueの時' do
          it 'article_requestが完成済みになる（statusが2になる）こと' do
            put api_v1_webgui_unapproved_article_path( @params )
            expect(ArticleRequest.first.status).to eq(2)
          end
        end

        context 'isSubmissionがfalseの時' do
          it 'article_requestが下書きになる（statusが1になる）こと' do
            @params[:isSubmission] = false
            put api_v1_webgui_unapproved_article_path( @params )
            expect(ArticleRequest.first.status).to eq(1)
          end
        end
        
      end
      context 'パラメータのarticle_requestが存在しない時' do
        it 'apiが400レスポンスを返すこと' do
          put api_v1_webgui_unapproved_article_path(
            :id => "test", 
            :session => sign_in[:session], 
            :email => create_writer_with_unapproved_article.email
          )
          expect(response).to have_http_status(400)
        end
      end
    end

    context 'サインインしてない時' do
      it 'apiが401レスポンスを返すこと' do
        put api_v1_webgui_unapproved_article_path(:id => "test", :session => "", :email => "")
        expect(response).to have_http_status(401)
      end
    end
  end

end
