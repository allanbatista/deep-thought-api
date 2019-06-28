require 'rails_helper'

RSpec.describe "Queries", type: :request do
  describe "GET /queries" do
    it "works! (now write some real specs)" do
      get queries_path
      expect(response).to have_http_status(200)
    end
  end
end
