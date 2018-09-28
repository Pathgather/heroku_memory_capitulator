class RestartsController < ApplicationController
  def create
    heroku_application = HerokuApplication.find(params[:heroku_application_id])
    HerokuAppRestarter.restart!(heroku_application, params[:payload])
    head :ok
  end
end
