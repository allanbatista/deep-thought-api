require 'rails_helper'

RSpec.describe Connection::MySQL, type: :model do
  context "#create" do
    it "should not create a connection base" do
      connection = Connection::Base.create(name: "MYSQL EXAMPLE")

      expect(connection).not_to be_persisted
      expect(connection.errors.messages).to eq({:type=>["not permite create a base connection."]})
    end
  end
end
