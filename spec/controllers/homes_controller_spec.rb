require 'rails_helper'
require 'csv'
RSpec.describe HomesController, type: :controller do
  describe 'GET /' do
    context 'without login user' do
      it 'should return 302' do
        get :index
        expect(response).to have_http_status(:redirect)
      end
    end
    context 'with login user' do
      it 'should return 200' do
        user = create(:user)
        sign_in user
        get :index
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'POST /load_generation' do
    it 'responds with success' do
      user = create(:user)
      sign_in user
      tempfile = Tempfile.new(['test_generation', '.csv'])
      CSV.open(tempfile, 'wb', col_sep: ';', headers: true) do |csv|
        csv <<  %w[. *]
        csv <<  %w[. .]
      end
      post :load_generation, params: {
        home: {
          file: fixture_file_upload(tempfile.path, 'text/csv')
        }
      }

      expect(response).to have_http_status(:redirect)
    end
  end
end
