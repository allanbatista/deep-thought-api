require 'rails_helper'

RSpec.describe "Namespaces", type: :request do

  describe "GET /namespaces" do
    it "" do
      get namespaces_path, {headers: {"Authentication" => User.first.jwt}}

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq([
        {
          "created_at"=>Namespace.first.created_at.to_s,
          "name"=>"Global",
          "namespace_id"=>nil,
          "updated_at"=>Namespace.first.updated_at.to_s,
          "id"=>Namespace.first.id.to_s
        }
      ])
    end
  end
end
