require 'rails_helper'

RSpec.describe ConnectionsController, type: :controller do
  before do
    Timecop.freeze(Time.local(2019))
    @user = User.create(email: "allan@allanbatista.com.br")
    @base = Connection::MySQL.create(name: "Base", host: "127.0.0.1")
    @mysql = Connection::MySQL.create(name: "MySQL", host: "localhost")
  end

  after do
    Timecop.return
  end

  it "need to be authenticated" do
    get :index
    expect(response.status).to eq(401)

    request.headers.merge!({ "Authentication" => @user.jwt })
    get :index
    expect(response.status).to eq(200)
  end

  context "#index" do
    before do
      request.headers.merge!({ "Authentication" => @user.jwt })
    end

    it "should list a connections" do
      get :index

      expect(response.status).to eq(200)
      expect(response.body).to eq([
        @base.as_json,
        @mysql.as_json
      ].to_json)
    end

    it "should get empty list" do
      Connection::Base.destroy_all

      get :index

      expect(response.status).to eq(200)
      expect(response.body).to eq('[]')
    end
  end

  context "#show" do
    before do
      request.headers.merge!({ "Authentication" => @user.jwt })
    end

    it "found" do
      get :show, params: { :id => @mysql.id.to_s }

      expect(response.status).to eq(200)
    end

    it "not found" do
      get :show, params: { :id => :NOT_FOUND }

      expect(response.status).to eq(404)
      expect(response.body).to eq('{"message":"Not Found"}')
    end
  end

  context "#create" do
    before do
      request.headers.merge!({ "Authentication" => @user.jwt })
    end

    it "should create new connection" do
      post :create, params: { name: "NEW MySQL", type: "MySQL", host: "localhost" }

      mysql = Connection::MySQL.find_by(name: "NEW MySQL")
      
      expect(response.status).to eq(201)
      
      expect(JSON.parse(response.body)).to eq({
        "id" => mysql.id.to_s,
        "name" => "NEW MySQL",
        "type" => "MySQL",
        "host" => "localhost",
        "port" => 3306,
        "username" => nil,
        "created_at" => mysql.created_at.as_json,
        "updated_at" => mysql.updated_at.as_json
      })
    end

    it "should not create without type" do
      post :create, params: { name: "NEW MySQL", host: "localhost" }
      
      expect(response.status).to eq(422)
      expect(response.body).to eq('{"message":"type is required"}')
    end

    it "should not create without a required params" do
      post :create, params: { name: "NEW MySQL", type: "MySQL" }
      
      expect(response.status).to eq(422)
      expect(response.body).to eq('{"host":["can\'t be blank"]}')
    end
  end

  context "#update" do
    before do
      request.headers.merge!({ "Authentication" => @user.jwt })
    end

    it "should update a connection" do
      patch :update, params: { id: @mysql.id.to_s, name: "MYSQL NAME 2" }

      expect(response.status).to eq(200)

      expect(@mysql.reload.name).to eq("MYSQL NAME 2")
    end

    it "not found" do
      patch :update, params: { id: :NOT_FOUND, name: "MYSQL NAME 2" }

      expect(response.status).to eq(404)
      expect(response.body).to eq('{"message":"Not Found"}')
    end
  end

  context "#destroy" do
    before do
      request.headers.merge!({ "Authentication" => @user.jwt })
    end

    it "should delete a connection" do
      delete :destroy, params: { id: @mysql.id.to_s }

      expect(response.status).to eq(204)

      expect(Connection::Base.find(@mysql.id)).to be_nil
    end

    it "should not raise error when try to delete a connection already removed" do
      @mysql.destroy

      delete :destroy, params: { id: @mysql.id.to_s }

      expect(response.status).to eq(204)
    end
  end
  
  context "#types" do
    before do
      request.headers.merge!({ "Authentication" => @user.jwt })
    end

    it "should list types" do
      get :types

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
