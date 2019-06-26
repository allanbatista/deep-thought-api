require 'rails_helper'

RSpec.describe ConnectionsController, type: :request do
  before do
    Timecop.freeze(Time.local(2019))
    @user = User.create(email: "allan@allanbatista.com.br")
    
    @namespace_creator = Namespace.create(name: "Other")
    @namespace_creator.permissions.create(user: @user, permissions: ["creator"])
    @namespace_without_permission = Namespace.create(name: "namespace_without_permission")

    @base = Connection::MySQL.create(name: "Base", host: "127.0.0.1", namespace: @namespace_without_permission)
    @mysql = Connection::MySQL.create(name: "MySQL", host: "localhost", namespace: @user.namespace)
    @mysql3 = Connection::MySQL.create(name: "MySQL3", host: "localhost", namespace: @namespace_creator)
  end

  after do
    Timecop.return
  end

  it "need to be authenticated" do
    get connections_path
    expect(response.status).to eq(401)

    get connections_path, headers: {"Authentication" => @user.jwt}
    expect(response.status).to eq(200)
  end

  context "#index" do
    it "should list a connections" do
      get connections_path, headers: {"Authentication" => @user.jwt}

      expect(response.status).to eq(200)
      expect(response.body).to eq([
        @mysql.as_json
      ].to_json)
    end

    it "should get empty list" do
      Connection::Base.destroy_all

      get connections_path, headers: {"Authentication" => @user.jwt}

      expect(response.status).to eq(200)
      expect(response.body).to eq('[]')
    end

    it "should list with namespaces defined" do
      get connections_path, params: { namespace: @namespace_creator.id }, headers: {"Authentication" => @user.jwt}

      expect(response.status).to eq(200)
      expect(response.body).to eq([
        @mysql3
      ].to_json)
    end
  end

  context "#show" do
    it "found" do
      get connection_path(@mysql), headers: {"Authentication" => @user.jwt}

      expect(response.status).to eq(200)
    end

    it "not found" do
      get connection_path("NOT FOUND"), headers: {"Authentication" => @user.jwt}

      expect(response.status).to eq(404)
      expect(response.body).to eq('{"message":"Not Found"}')
    end

    it "not found connection when user has no namespace permission" do
      get connection_path(@base), headers: {"Authentication" => @user.jwt}

      expect(response.status).to eq(404)
      expect(response.body).to eq('{"message":"Not Found"}')
    end
  end

  context "#create" do

    it "should create new connection" do
      post connections_path, params: { name: "NEW MySQL", type: "MySQL", host: "localhost" }, headers: {"Authentication" => @user.jwt}

      mysql = Connection::MySQL.find_by(name: "NEW MySQL")
      
      expect(response.status).to eq(201)
      
      expect(JSON.parse(response.body)).to eq({
        "id" => mysql.id.to_s,
        "name" => "NEW MySQL",
        "type" => "MySQL",
        "host" => "localhost",
        "port" => 3306,
        "username" => nil,
        "namespace_id" => @user.namespace.id.to_s,
        "created_at" => mysql.created_at.as_json,
        "updated_at" => mysql.updated_at.as_json
      })
    end

    it "should create a conneciton with other namespace" do
      post connections_path, params: { name: "NEW MySQL", type: "MySQL", host: "localhost", namespace_id: @namespace_creator.id }, headers: {"Authentication" => @user.jwt}

      mysql = Connection::MySQL.find_by(name: "NEW MySQL")
      
      expect(response.status).to eq(201)
      
      expect(JSON.parse(response.body)).to eq({
        "id" => mysql.id.to_s,
        "name" => "NEW MySQL",
        "type" => "MySQL",
        "host" => "localhost",
        "port" => 3306,
        "username" => nil,
        "namespace_id" => @namespace_creator.id.to_s,
        "created_at" => mysql.created_at.as_json,
        "updated_at" => mysql.updated_at.as_json
      })
    end

    it "should not create a connection with a namespace that user has no permission" do
      post connections_path, params: { name: "NEW MySQL", type: "MySQL", host: "localhost", namespace_id: @namespace_without_permission.id }, headers: {"Authentication" => @user.jwt}

      mysql = Connection::MySQL.find_by(name: "NEW MySQL")
      
      expect(response.status).to eq(403)
      expect(response.body).to eq('{"message":"user has no enough permission to this namespace to execute this action"}')
    end

    it "should not create without type" do
      post connections_path, params: { name: "NEW MySQL", host: "localhost" }, headers: {"Authentication" => @user.jwt}
      
      expect(response.status).to eq(422)
      expect(response.body).to eq('{"message":"type is required"}')
    end

    it "should not create without a required params" do
      post connections_path, params: { name: "NEW MySQL", type: "MySQL" }, headers: {"Authentication" => @user.jwt}
      
      expect(response.status).to eq(422)
      expect(response.body).to eq('{"host":["can\'t be blank"]}')
    end
  end

  context "#update" do
    it "should update a connection" do
      patch connection_path(@mysql), params: { name: "MYSQL NAME 2" }, headers: {"Authentication" => @user.jwt}

      expect(response.status).to eq(200)

      expect(@mysql.reload.name).to eq("MYSQL NAME 2")
    end

    it "not found" do
      patch connection_path(:NOT_FOUND), params: { name: "MYSQL NAME 2" }, headers: {"Authentication" => @user.jwt}

      expect(response.status).to eq(404)
      expect(response.body).to eq('{"message":"Not Found"}')
    end

    it "should not process entity" do
      patch connection_path(@mysql), params: { name: "Base" }, headers: {"Authentication" => @user.jwt}

      expect(response.status).to eq(422)
    end
  end

  context "#destroy" do
    it "should delete a connection" do
      delete connection_path(@mysql), headers: {"Authentication" => @user.jwt}

      expect(response.status).to eq(204)

      expect(Connection::Base.find(@mysql.id)).to be_nil
    end

    it "should not raise error when try to delete a connection already removed" do
      @mysql.destroy

      delete connection_path(@mysql.id), headers: {"Authentication" => @user.jwt}

      expect(response.status).to eq(404)
    end
  end
  
  context "#types" do
    it "should list types" do
      get types_connections_path, headers: {"Authentication" => @user.jwt}

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq([
        {
          "type"=>"MySQL",
          "fields"=>{
            "name"=>{"type"=>"string", "required"=>true},
            "host"=>{"type"=>"string", "required"=>true},
            "port"=>{"type"=>"interger", "required"=>true, "default"=>3306},
            "username"=>{"type"=>"string"},
            "password"=>{"type"=>"string"}
          }
        }
      ])
    end
  end
end
