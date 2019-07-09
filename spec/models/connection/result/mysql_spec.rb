require 'rails_helper'

RSpec.describe Connection::Result::MySQL do
  before do
    @connection = Connection::MySQL.create(name: "MYSQL EXAMPLE", host: "127.0.0.1", username: 'root', database: 'deep_thought_test')
  end

  context "#to_a" do
    it "should execute a lazy executor" do
      @connection.client.execute("select * from users") do |result|
        expect(result.to_a).to eq([[1, 'allan'], [2, 'alessandra']])
      end
    end
  end

  context "#to_tsv" do
    it "should convert to tsv file" do
      @connection.client.execute("select * from users") do |result|
        result.to_tsv("#{Rails.root}/tmp/filename.csv")
        expect(File.read("#{Rails.root}/tmp/filename.csv")).to eq(%{id\tname
1\tallan
2\talessandra
})
      end
    end
  end

  context "#to_json" do
    it "should convert results to json" do
      @connection.client.execute("select * from users") do |result|
        result.to_json("#{Rails.root}/tmp/filename.json")
        expect(File.read("#{Rails.root}/tmp/filename.json")).to eq("{\"id\":1,\"name\":\"allan\"}\n{\"id\":2,\"name\":\"alessandra\"}\n")
      end
    end
  end
end
