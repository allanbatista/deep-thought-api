require 'rails_helper'

RSpec.describe Connection::MySQL, type: :model do
  context "#create" do
    it "should not create a connection without name, host and port" do
      connection = Connection::MySQL.create(name: "MYSQL EXAMPLE", username: 'root')
      expect(connection).not_to be_persisted

      connection = Connection::MySQL.create(name: "MYSQL EXAMPLE", host: "127.0.0.1", username: 'root')
      expect(connection).to be_persisted
      expect(connection.port).to eq(3306)
    end

    it "should not create a connection with duplicate name" do
      connection = Connection::MySQL.create(name: "MYSQL EXAMPLE", host: "127.0.0.1", username: 'root')
      expect(connection).to be_persisted

      connection = Connection::MySQL.create(name: "MYSQL EXAMPLE", host: "127.0.0.1", username: 'root')
      expect(connection).not_to be_persisted
    end
  end

  context "#execute" do
    before do
      @connection = Connection::MySQL.create(name: "MYSQL EXAMPLE", host: "127.0.0.1", username: 'root')
    end

    it "should execute a lazy executor" do
      expect(@connection.client).to be_a(Connection::Adapter::MySQL)
    end
  end
end
