require 'rails_helper'

RSpec.describe "Namespaces", type: :request do

  describe "GET /namespaces" do
    it "list namespaces" do
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

  describe "GET /namespaces/:id" do
    it "show namespace" do
      get namespace_path(Namespace.first), {headers: {"Authentication" => User.first.jwt}}

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
        {
          "created_at"=>Namespace.first.created_at.to_s,
          "name"=>"Global",
          "namespace_id"=>nil,
          "updated_at"=>Namespace.first.updated_at.to_s,
          "id"=>Namespace.first.id.to_s
        }
      )
    end

    it "not found" do
      get namespace_path("NOT_FOUND"), {headers: {"Authentication" => User.first.jwt}}

      expect(response).to have_http_status(404)
    end
  end

  describe "DELETE /namespaces/:id" do
    it "delete namespace" do
      delete namespace_path(Namespace.first), {headers: {"Authentication" => User.first.jwt}}

      expect(response).to have_http_status(204)

      expect(Namespace.first).to be_blank
    end
  end

  describe "POST /namespaces" do
    it "should create a new namespace" do
      post namespaces_path, {params: {name: "developers", namespace_id: Namespace.first.id.to_s}, headers: {"Authentication" => User.first.jwt}}

      namespace = Namespace.last

      expect(response).to have_http_status(201)
      expect(JSON.parse(response.body)).to eq(
        {
          "created_at"=>namespace.created_at.to_s,
          "name"=>"developers",
          "namespace_id"=>Namespace.first.id.to_s,
          "updated_at"=>namespace.updated_at.to_s,
          "id"=>namespace.id.to_s
        }
      )

      expect(namespace.permissions.first.user).to eq(User.first)
      expect(namespace.permissions.first.permissions).to eq(["owner"])
    end

    it "should not create without name" do
      post namespaces_path, {params: {namespace_id: Namespace.first.id.to_s}, headers: {"Authentication" => User.first.jwt}}

      namespace = Namespace.last

      expect(response).to have_http_status(422)
    end
  end

  describe "PATCH /namespaces/:id" do
    it "should create a new namespace" do
      patch namespace_path(Namespace.first.id.to_s), {params: {name: "developers"}, headers: {"Authentication" => User.first.jwt}}

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
        {
          "created_at"=>Namespace.first.created_at.to_s,
          "name"=>"developers",
          "namespace_id"=>nil,
          "updated_at"=>Namespace.first.updated_at.to_s,
          "id"=>Namespace.first.id.to_s
        }
      )
    end

    it "not found" do
      patch namespace_path("NOT_FOUND"), {headers: {"Authentication" => User.first.jwt}}

      expect(response).to have_http_status(404)
    end

    it "should not update a namespace without name" do
      patch namespace_path(Namespace.first.id.to_s), {params: {name: nil}, headers: {"Authentication" => User.first.jwt}}

      expect(response).to have_http_status(422)
    end
  end
end
