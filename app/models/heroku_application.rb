class HerokuApplication < ApplicationRecord
  has_many :restarts
  attr_encrypted :oauth_token, key: Rails.application.credentials.hash_256

  def restarts_disabled?
    return unless last_restart = restarts.order(restarted_at: :asc).last
    last_restart.restarted_at > grace_period.seconds.ago
  end
end
