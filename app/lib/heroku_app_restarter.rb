module HerokuAppRestarter
  def self.restart!(heroku_application, payload)
    dyno_name = dyno_name_from(payload)
    return if heroku_application.restarts_disabled?(dyno_name)

    heroku_application.restarts.create!(dyno_name: dyno_name)
    heroku = PlatformAPI.connect_oauth(heroku_application.oauth_token)
    heroku.dyno.restart(heroku_application.name, dyno_name)
  end

  # receives payload as JSON
  def self.dyno_name_from(payload)
    payload = HashWithIndifferentAccess.new(Yajl::Parser.parse(payload))

    # In 100% of the cases so far, only one dyno had memory problems at
    # a time. To keep this simple, let's restart them only one at a time
    # (by taking only one event from the payload). The webhook is run every
    # minute so even if multiple dynos are having a hard time, they can be
    # handled next time we receive the webhook.
    program = payload[:events][0][:program]

    # this is in format 'heroku/<dyno_name>'
    program.gsub!(/^heroku\//, '')
  end
end
