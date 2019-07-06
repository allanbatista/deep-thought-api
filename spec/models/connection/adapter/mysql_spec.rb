require 'rails_helper'

RSpec.describe Connection::Adapter::MySQL do
  before do
    @adapter = Connection::Adapter::MySQL.new(host: "127.0.0.1", username: "root")
  end

  context "#connect?" do
    it "should connect successful" do
      expect(@adapter).to be_connect
    end

    it "should not connect" do
      adapter_fail = Connection::Adapter::MySQL.new(host: "127.0.0.1", username: "root", port: 3307)
      expect(adapter_fail).not_to be_connect
    end
  end

  context "#execute" do
    before do
      @connection = Connection::MySQL.create(name: "MYSQL EXAMPLE", host: "127.0.0.1", username: 'root', database: 'deep_thought_test')
    end

    it "should execute a lazy executor" do
      @connection.client.execute("select * from users") do |result|
        expect(result).to be_a(Connection::Result::MySQL)
      end
    end
  end
end
