class RestartsController < ApplicationController
  def create
    heroku_application = HerokuApplication.find(params[:heroku_application_id])
    HerokuAppRestarter.restart!(heroku_application)
    head :ok
  end
end
