module HerokuAppRestarter
  def self.restart!(heroku_application)
    return if heroku_application.restarts_disabled?
    heroku_application.restarts.create!(restarted_at: Time.now)
    heroku = PlatformAPI.connect_oauth(heroku_application.oauth_token)
    heroku.dyno.restart_all(heroku_application.name)
  end
end
