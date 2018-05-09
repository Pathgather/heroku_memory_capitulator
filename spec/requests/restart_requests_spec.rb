require 'rails_helper'

describe 'Webhooks Indicating Restart is Needed', type: :request do
  before do
    @heroku_application = create(:heroku_application)
  end
  describe '/heroku_applications/:id/restart_request' do
    context 'no prior restart has been executed' do
      it 'initiates the restart' do
        expect(HerokuAppRestarter)
          .to receive(:restart!).with(@heroku_application)
        post "/heroku_applications/#{@heroku_application.id}/restarts",
          params: { events: [ { id: 'id' } ] }
      end
    end
  end
end
