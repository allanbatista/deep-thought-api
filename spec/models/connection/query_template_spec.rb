require 'rails_helper'

RSpec.describe Connection::QueryTemplate do
  before { Timecop.freeze(Time.local(2019)) }
  after { Timecop.return }

  context ".format" do
    it "should format without any variable" do
      sql = Connection::QueryTemplate.format("SELECT * FROM `users`")

      expect(sql).to eq("SELECT * FROM `users`")
    end

    it "should format with variable" do
      sql = Connection::QueryTemplate.format("SELECT * FROM `users` where id = <%= id %>", {id: 1})

      expect(sql).to eq("SELECT * FROM `users` where id = 1")
    end

    it "should format use ruby methods" do
      sql = Connection::QueryTemplate.format('SELECT * FROM `users` where date = "<%= 1.day.ago.to_date %>"')

      expect(sql).to eq('SELECT * FROM `users` where date = "2018-12-31"')
    end

    it "should raise exception with insecury operation" do
      expect {
        Connection::QueryTemplate.format('SELECT * FROM `users` where date = "<%= User.first %>"')
      }.to raise_error SecurityError
    end
  end
end
