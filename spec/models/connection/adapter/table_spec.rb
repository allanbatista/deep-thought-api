require 'rails_helper'

RSpec.describe Connection::Adapter::Table do
  before do
    @adapter = Connection::Adapter::MySQL.new(host: "127.0.0.1", username: "root")
  end

  context "#describe" do
    it "describe table" do
      db = @adapter.database('deep_thought_test')
      table = db.table('users')

      expect(table.describe).to eq([
        Connection::Adapter::Field.new("id", "int(11)"),
        Connection::Adapter::Field.new("name", "varchar(45)")
      ])
    end
  end
end
