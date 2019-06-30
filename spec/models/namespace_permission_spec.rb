require 'rails_helper'

RSpec.describe NamespacePermission, type: :model do
  context "#create" do
    it "should create a namespace" do
      np = NamespacePermission.create(user: User.first, namespace: Namespace.first, permissions: ["viewer"])

      expect(np).to be_persisted
    end

    it "should not create a permission is not exists" do
      np = NamespacePermission.create(user: User.first, namespace: Namespace.first, permissions: ["NOT_EXISTS", "viewer", "NOT_OTHER"])

      expect(np).not_to be_persisted
      expect(np.errors.messages).to eq({:permissions=>["NOT_EXISTS,NOT_OTHER permissions not permisted"]})
    end
  end
end
