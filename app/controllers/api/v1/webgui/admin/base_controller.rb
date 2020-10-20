class Api::V1::Webgui::Admin::BaseController < ApplicationController
  @base_worker = BaseWorker.new()
end
