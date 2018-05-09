describe HerokuAppRestarter do
  before do
    @heroku_application = create(
      :heroku_application, oauth_token: 'token', grace_period: 1800
    )
    allow(PlatformAPI).to receive(:connect_oauth).with('token').and_return(
      double(dyno: double(restart_all: true))
    )
  end
  describe '::restart!' do
    it 'restarts an app via the heroku platform api' do
      expect(PlatformAPI).to receive(:connect_oauth).with('token').and_return(
        double(dyno: double(restart_all: true))
      )
      HerokuAppRestarter.restart!(@heroku_application)
      expect(@heroku_application.restarts.count).to eq 1
    end
    context 'a restart is triggered within the predefined grace period' do
      before do
        create(:restart, heroku_application: @heroku_application,
               restarted_at: 1.minute.ago)
      end
      it 'does NOT initiate the restart' do
        HerokuAppRestarter.restart!(@heroku_application)
        expect(@heroku_application.restarts.count).to eq 1
      end
    end
    context 'a restart is triggered after the grace period has ended' do
      before do
        create(:restart, heroku_application: @heroku_application,
               restarted_at: 1.hour.ago)
      end
      it 'initiates the restart' do
        HerokuAppRestarter.restart!(@heroku_application)
        expect(@heroku_application.restarts.count).to eq 2
      end
    end
  end
end
