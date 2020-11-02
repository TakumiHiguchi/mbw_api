require 'rails_helper'

RSpec.describe "Api::V1::Webgui::PlanRegisters", type: :request do

  describe 'GET /api/v1/webgui/plan_register/:id' do
    let(:plan_register){ FactoryBot.create(:plan_register) }
    it 'apiが200レスポンスを返すこと' do
      plan_register
      get api_v1_webgui_plan_register_path(id: plan_register.key,session: plan_register.session)
      expect(response).to have_http_status(200)
    end
    it 'PlanRegisterが帰ってくること' do
      get api_v1_webgui_plan_register_path(id: plan_register.key,session: plan_register.session)
      expect(JSON.parse(response.body)["result"][0]["name"]).to eq(plan_register.name)
    end
  end
end