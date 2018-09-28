require 'rails_helper'

describe HerokuApplication do
  before do
    @heroku_application = create(
      :heroku_application, oauth_token: 'token', grace_period: 1800
    )
  end

  describe 'restarts_disabled?' do
    context 'no restarts found' do
      it 'returns true' do
        expect(@heroku_application.restarts_disabled?('web.1')).to eq false
      end
    end

    context 'restarts are present' do
      context 'own restarts within grace period' do
        it 'returns true' do
          dyno_name = 'web.1'
          create(:restart, heroku_application: @heroku_application,
                 restarted_at: 5.minutes.ago, dyno_name: dyno_name)
          expect(@heroku_application.restarts_disabled?(dyno_name)).to eq true
        end
      end

      context 'own restarts outside of grace period' do
        it 'returns false' do
          dyno_name = 'web.1'
          create(:restart, heroku_application: @heroku_application,
                 restarted_at: 1.hour.ago, dyno_name: dyno_name)
          expect(@heroku_application.restarts_disabled?(dyno_name)).to eq false
        end
      end

      context 'no own restarts within grace period' do
        it 'returns false' do
          dyno_name = 'web.1'
          create(:restart, heroku_application: @heroku_application,
                 restarted_at: 5.minutes.ago, dyno_name: 'sidekiq.3')
          expect(@heroku_application.restarts_disabled?(dyno_name)).to eq false
        end
      end

      context 'no own restarts outside grace period' do
        it 'returns false' do
          dyno_name = 'web.1'
          create(:restart, heroku_application: @heroku_application,
                 restarted_at: 1.hour.ago, dyno_name: 'sidekiq.3')
          expect(@heroku_application.restarts_disabled?(dyno_name)).to eq false
        end
      end
    end
  end
end
