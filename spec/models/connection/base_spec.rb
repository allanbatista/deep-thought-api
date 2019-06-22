require 'rails_helper'

RSpec.describe Connection::Base, type: :model do
  context "#create" do
    it "should not create a connection without name" do
      connection = Connection::Base.create
      expect(connection).not_to be_persisted

      connection = Connection::Base.create(name: "Example")
      expect(connection).to be_persisted
    end

    it "should not create a connection with duplicate name" do
      connection = Connection::Base.create(name: "Example")
      expect(connection).to be_persisted

      connection = Connection::Base.create(name: "Example")
      expect(connection).not_to be_persisted
    end
  end
end
