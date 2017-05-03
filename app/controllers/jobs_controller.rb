class JobsController < ApplicationController
  before_action :set_app
  def show
    @job = @app.jobs.find(params[:id])
  end

  private
  def set_app
    @platform = Platform.find(params[:platform_id])
    @app = @platform.apps.find(params[:app_id])

  end
end
