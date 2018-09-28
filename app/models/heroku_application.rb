class HerokuApplication < ApplicationRecord
  has_many :restarts
  attr_encrypted :oauth_token, key: Rails.application.credentials.hash_256

  def restarts_disabled?(dyno_name)
    last_restart = restarts.where(dyno_name: dyno_name).order(restarted_at: :asc).last
    return false unless last_restart
    last_restart.restarted_at > grace_period.seconds.ago
  end
end
