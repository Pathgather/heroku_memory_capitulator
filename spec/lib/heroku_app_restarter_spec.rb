require 'rails_helper'

describe HerokuAppRestarter do
  before do
    @heroku_application = create(
      :heroku_application, oauth_token: 'token', grace_period: 1800
    )
    @payload = read_fixtures(path: 'payload.json')
    allow(PlatformAPI).to receive(:connect_oauth).with('token').and_return(
      double(dyno: double(restart: true))
    )
  end

  describe '::restart!' do
    it 'restarts an app via the heroku platform api' do
      expect(PlatformAPI).to receive(:connect_oauth).with('token').and_return(
        double(dyno: double(restart: true))
      )
      HerokuAppRestarter.restart!(@heroku_application, @payload)
      expect(@heroku_application.restarts.count).to eq 1
    end

    context 'a restart is triggered within the predefined grace period' do
      before do
        create(:restart, heroku_application: @heroku_application,
               restarted_at: 1.minute.ago)
      end
      it 'does NOT initiate the restart' do
        HerokuAppRestarter.restart!(@heroku_application, @payload)
        expect(@heroku_application.restarts.count).to eq 1
      end
    end

    context 'a restart is triggered after the grace period has ended' do
      before do
        create(:restart, heroku_application: @heroku_application,
               restarted_at: 1.hour.ago)
      end
      it 'initiates the restart' do
        HerokuAppRestarter.restart!(@heroku_application, @payload)
        expect(@heroku_application.restarts.count).to eq 2
      end
    end
  end

  describe '::dyno_name_from' do
    it 'extracts dyno name correctly' do
      name = HerokuAppRestarter.dyno_name_from(@payload)
      expect(name).to eq 'web.2'
    end
  end
end
