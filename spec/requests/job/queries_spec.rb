require 'rails_helper'

RSpec.describe "Job::Queries", type: :request do
  before do
    Timecop.freeze(Time.local(2019))

    @user = User.create(email: "allan@allanbatista.com.br")
    @other_user = User.find_by(email: "user@example.com")
    
    @namespace_creator = Namespace.create(name: "Other")
    @namespace_creator.permissions.create(user: @user, permissions: ["creator"])
    @namespace_creator.permissions.create(user: @other_user, permissions: ["creator"])
    @subnamespace_creator = Namespace.create(name: "subNamespace", namespace: @namespace_creator)
    @subnamespace_creator.permissions.create(user: @user, permissions: ["creator"])
    @subnamespace_creator.permissions.create(user: @other_user, permissions: ["creator"])
    @namespace_without_permission = Namespace.create(name: "namespace_without_permission")
    @namespace_without_permission.permissions.create(user: @other_user, permissions: ["creator"])

    @base = Connection::MySQL.create(name: "Base", host: "127.0.0.1", username: "root", namespace: @namespace_without_permission, database: 'deep_thought_test')
    @mysql = Connection::MySQL.create(name: "MySQL", host: "127.0.0.1", username: "root", namespace: @user.namespace, database: 'deep_thought_test')
    @mysql3 = Connection::MySQL.create(name: "MySQL3", host: "127.0.0.1", username: "root", namespace: @namespace_creator, database: 'deep_thought_test')
    @mysql4 = Connection::MySQL.create(name: "MySQL3", host: "127.0.0.1", username: "root", namespace: @subnamespace_creator, database: 'deep_thought_test')
  end

  after { Timecop.return } 

  it "need to be authenticated" do
    get job_queries_path
    expect(response).to have_http_status(401)

    get job_queries_path, headers: {"Authentication" => @user.jwt}
    expect(response).to have_http_status(200)
  end

  describe "GET /job/queries" do
    before do
      Timecop.return

      @query1 = Job::Query.create(user: @user, namespace: @namespace_creator, query: "SELECT * FROM `deep_thought_test`.`users`;", connection: @mysql3)
      @query2 = Job::Query.create(user: @other_user, namespace: @namespace_creator, query: "SELECT * FROM `deep_thought_test`.`users`;", connection: @mysql3)
      @query3 = Job::Query.create(user: @user, namespace: @subnamespace_creator, query: "SELECT * FROM `deep_thought_test`.`users`;", connection: @mysql4)
      @query4 = Job::Query.create(user: @other_user, namespace: @subnamespace_creator, query: "SELECT * FROM `deep_thought_test`.`users`;", connection: @mysql4)
      @query5 = Job::Query.create(user: @other_user, namespace: @namespace_without_permission, query: "SELECT * FROM `deep_thought_test`.`users`;", connection: @base)
    end

    it "should list jobs with decrescent created order" do
      get job_queries_path, params: { namespace: @namespace_creator.id.to_s }, headers: {"Authentication" => @user.jwt}

      expect(response).to have_http_status(200)
      expect(response.body).to eq([
        @query4,
        @query3,
        @query2,
        @query1
      ].to_json)
    end


  end
end
