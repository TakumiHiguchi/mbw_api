class Api::V1::Webgui::BaseController < ApplicationController
  @@base_worker = BaseWorker.new()
  @@renderJson = RenderJson.new()
  @auth = Authentication.new()
end
