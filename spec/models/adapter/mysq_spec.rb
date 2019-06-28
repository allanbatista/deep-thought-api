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
    it "should execute a query" do
      @adapter.execute("select * from db_test.new_table;") do |result|
        expect(result).to be_a(Connection::Result::MySQL)
        expect(result.to_a).to eq([[1, "allan"], [2, "arley"], [3, "alessandra"]])
      end
    end
  end
end
