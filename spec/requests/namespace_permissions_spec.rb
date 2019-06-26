require 'rails_helper'

RSpec.describe "NamespacePermissinos", type: :request do

  before do
    @user = User.first
    @user2 = User.create(name: "User2", email: "user2@example.com")

    @namespace_global = Namespace.find_by(name: "Global")
    @permission_global = @namespace_global.permissions.create(user: @user, permissions: ["viewer"])

    @namespace = Namespace.create(name: "Teste", namespace: @namespace_global)
    @permission = @namespace.permissions.create(user: @user, permissions: ["owner"])

    @namespace_sub = Namespace.create(name: "Sub teste", namespace: @namespace)
    @permission_sub = @namespace_sub.permissions.create(user: @user, permissions: ["viewer"])
  end

  describe "GET /namespace/:namespace_id/permissions" do
    it "list permissions when is owner" do
      get namespace_permissions_path(@namespace), {headers: {"Authentication" => @user.jwt}}

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq([
        {
          "created_at"=>@namespace.created_at.to_s,
          "namespace_id"=>@namespace.id.to_s,
          "permissions"=>["owner"],
          "updated_at"=>@namespace.updated_at.to_s,
          "user_id"=>@user.id.to_s,
          "id"=>@permission.id.to_s
        }
      ])
    end

    it "should not list anything without a namespace" do
      get namespace_permissions_path("NOT_FOUND"), {headers: {"Authentication" => @user.jwt}}

      expect(response).to have_http_status(403)
      expect(response.body).to eq("{\"message\":\"namespace is required\"}")
    end

    it "should not do nothing with permissions with is not owner" do
      get namespace_permissions_path(@namespace_global), {headers: {"Authentication" => @user.jwt}}

      expect(response).to have_http_status(403)
      expect(response.body).to eq("{\"message\":\"user has no enough permission to this namespace to execute this action\"}")
    end

    it "should inherit permissions from parent namespace" do
      get namespace_permissions_path(@namespace_sub), {headers: {"Authentication" => @user.jwt}}

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq([
        {
          "created_at"=>@namespace_sub.created_at.to_s,
          "namespace_id"=>@namespace_sub.id.to_s,
          "permissions"=>["viewer"],
          "updated_at"=>@namespace_sub.updated_at.to_s,
          "user_id"=>@user.id.to_s,
          "id"=>@permission_sub.id.to_s
        }
      ])
    end
  end

  describe "GET /namespace/:namespace_id/permissions/:id" do
    it "show namespace" do
      get namespace_permission_path(@namespace, @permission), {headers: {"Authentication" => @user.jwt}}

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
        {
          "created_at"=>@namespace.created_at.to_s,
          "namespace_id"=>@namespace.id.to_s,
          "permissions"=>["owner"],
          "updated_at"=>@namespace.updated_at.to_s,
          "user_id"=>@user.id.to_s,
          "id"=>@permission.id.to_s
        }
      )
    end

    it "not found a permission" do
      get namespace_permission_path(@namespace, "NOT_FOUND"), {headers: {"Authentication" => @user.jwt}}

      expect(response).to have_http_status(404)
    end
  end

  describe "DELETE /namespaces/:namespace_id/permissions/:id" do
    it "delete namespace" do
      delete namespace_permission_path(@namespace, @permission), {headers: {"Authentication" => @user.jwt}}

      expect(response).to have_http_status(204)

      expect(NamespacePermission.find(@permission.id)).to be_blank
    end

    it "not found a permission" do
      delete namespace_permission_path(@namespace, "NOT_FOUND"), {headers: {"Authentication" => @user.jwt}}

      expect(response).to have_http_status(404)
    end
  end

  describe "POST /namespaces/:namespace_id/permissions" do

    it "should create a new permission" do
      post namespace_permissions_path(@namespace), {params: {permissions: ['viewer'], user_id: @user2.id.to_s}, headers: {"Authentication" => @user.jwt}}

      expect(response).to have_http_status(201)

      permission = @namespace.permissions.find_by(user: @user2)
      
      expect(JSON.parse(response.body)).to eq({
        "created_at"=>permission.created_at.to_s,
        "namespace_id"=>permission.namespace.id.to_s,
        "permissions"=>["viewer"],
        "updated_at"=>permission.updated_at.to_s,
        "user_id"=>@user2.id.to_s,
        "id"=>permission.id.to_s
      })

      expect(permission.permissions).to eq(['viewer'])
    end

    it "should not create without user" do
      post namespace_permissions_path(@namespace), {params: {}, headers: {"Authentication" => @user.jwt}}

      expect(response).to have_http_status(422)
    end

    it "should create without permission permited" do
      post namespace_permissions_path(@namespace), {params: {permissions: ['NOT_PERMITED'], user_id: @user2.id.to_s}, headers: {"Authentication" => @user.jwt}}

      expect(response).to have_http_status(422)
    end
  end

  describe "PATCH /namespaces/:namespace_id/permissions/:id" do
    it "should update permissions" do
      patch namespace_permission_path(@permission_sub.namespace, @permission_sub), {params: {permissions: ['viewer', 'creator']}, headers: {"Authentication" => @user.jwt}}

      expect(response).to have_http_status(200)
      permission = @permission_sub.reload
      
      expect(JSON.parse(response.body)).to eq({
        "created_at"=>permission.created_at.to_s,
        "namespace_id"=>permission.namespace.id.to_s,
        "permissions"=>["viewer", "creator"],
        "updated_at"=>permission.updated_at.to_s,
        "user_id"=>@permission_sub.user_id.to_s,
        "id"=>permission.id.to_s
      })
    end

    it "not found" do
      patch namespace_permission_path(@namespace, "NOT_FOUND"), {headers: {"Authentication" => @user.jwt}}

      expect(response).to have_http_status(404)
    end
  end
end
