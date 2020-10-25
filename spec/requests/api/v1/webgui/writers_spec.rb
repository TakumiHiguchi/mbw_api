require 'rails_helper'

RSpec.describe "Api::V1::Webgui::Writers", type: :request do
  let(:create_writer){ FactoryBot.create(:writer) }
  let(:create_plan_register){ FactoryBot.create(:plan_register) }

  describe 'Post /api/v1/webgui/signin' do
    context 'サインインに成功した時' do
      it 'apiが200レスポンスを返すこと' do
        post api_v1_webgui_writer_signin_path(:email => create_writer.email, :phrase => "test")
        expect(response).to have_http_status(200)
      end
    end

    context 'サインインに失敗した時' do
      it 'apiが404レスポンスを返すこと' do
        post api_v1_webgui_writer_signin_path(:email => create_writer.email, :phrase => "test__")
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'Post /api/v1/webgui/signup' do
    context 'サインアップに成功した時' do
      it 'apiが200レスポンスを返すこと' do        
        post api_v1_webgui_writer_signup_path(:session => create_plan_register.session, :key => create_plan_register.key, :email => create_plan_register.email, :phrase => "Koop9900")
        expect(response).to have_http_status(200)
      end
    end

    context 'サインアップに失敗した時' do
      it 'パスワードの形式があってなかった時apiが204レスポンスを返すこと' do
        post api_v1_webgui_writer_signup_path(:session => create_plan_register.session, :key => create_plan_register.key, :email => create_plan_register.email, :phrase => "test__")
        expect(response).to have_http_status(204)
      end
    end
  end
end
