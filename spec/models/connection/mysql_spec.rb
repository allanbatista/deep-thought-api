require 'rails_helper'

RSpec.describe Connection::MySQL, type: :model do
  context "#create" do
    it "should not create a connection without name, host and port" do
      connection = Connection::MySQL.create(name: "MYSQL EXAMPLE")
      expect(connection).not_to be_persisted

      connection = Connection::MySQL.create(name: "MYSQL EXAMPLE", host: "localhost")
      expect(connection).to be_persisted
      expect(connection.port).to eq(3306)
    end

    it "should not create a connection with duplicate name" do
      connection = Connection::MySQL.create(name: "MYSQL EXAMPLE", host: "localhost")
      expect(connection).to be_persisted

      connection = Connection::MySQL.create(name: "MYSQL EXAMPLE", host: "localhost")
      expect(connection).not_to be_persisted
    end
  end
end
