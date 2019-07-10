require 'rails_helper'

RSpec.describe Connection::Adapter::Database do
  before do
    @adapter = Connection::Adapter::MySQL.new(host: "127.0.0.1", username: "root")
  end

  context "#tables" do
    it "list tables" do
      db = @adapter.database('deep_thought_test')

      expect(db.tables).to be_a(Array)
      expect(db.tables.first).to be_a(Connection::Adapter::Table)

      expect(db.tables.first.database).to eq(db)
      expect(db.tables.first.client).to eq(@adapter)
    end
  end

  context "#table" do
    it "get table" do
      db = @adapter.database('deep_thought_test')
      table = db.table('users')

      expect(table).to eq(db.tables.first)
      expect(table).to be_a(Connection::Adapter::Table)

      expect(table.database).to eq(db)
      expect(table.client).to eq(@adapter)
    end
  end
end
