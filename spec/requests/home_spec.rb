require 'rails_helper'

RSpec.describe "Root Path", type: :request do
  describe "GET /" do
    it "returns a success JSON response" do
      get "/"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['status']).to eq('online')
      expect(json['message']).to include('API is running')
    end
  end
end
