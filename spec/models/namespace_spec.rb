require 'rails_helper'

RSpec.describe Namespace, type: :model do
  context "#context" do
    it "should create a namespace" do
      namespace = Namespace.create(name: "Developers")

      expect(namespace).to be_persisted
    end

    it "should not create namespaces with same name" do
      namespace = Namespace.create(name: "Global")

      expect(namespace).not_to be_persisted
    end
  end
end
