require 'rails_helper'

describe 'Webhooks Indicating Restart is Needed', type: :request do
  before do
    @heroku_application = create(:heroku_application)
    @payload = read_fixtures(path: 'payload.json')
  end
  describe '/heroku_applications/:id/restart_request' do
    context 'no prior restart has been executed' do
      it 'initiates the restart' do
        expect(HerokuAppRestarter)
          .to receive(:restart!).with(@heroku_application, @payload)
        post "/heroku_applications/#{@heroku_application.id}/restarts",
          params: { payload: @payload }
      end
    end
  end
end
