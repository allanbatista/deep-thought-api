require 'rails_helper'

RSpec.describe Rabbit do
  context ".instance" do
    it "should create only one instance of rabbit" do
      expect(Rabbit.instance).to eq(Rabbit.instance)
      expect(Rabbit.instance).to be_a(Rabbit)
    end
  end

  context "#channel" do
    it "should create a channel" do
      expect(Rabbit.instance.channel).to eq(Rabbit.instance.channel)
      expect(Rabbit.instance.channel).to be_a(Bunny::Channel)
    end
  end

  context "#exchange" do
    it "should create exchange and keep in cache" do
      Rabbit.instance.exchange("teste")

      expect(Rabbit.instance.exchanges["teste"]).to be_a(Bunny::Exchange)
    end
  end

  context "#enqueue" do
    it "should create exchange and keep in cache" do
      expect_any_instance_of(Bunny::Exchange).to receive(:publish).with(1)

      Rabbit.instance.enqueue("teste", 1)
    end
  end
end
