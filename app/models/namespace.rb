class Namespace
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :namespace, optional: true
  has_many :permissions, class_name: "NamespacePermission"

  field :name, type: String

  validates :name, presence: true, uniqueness: true

  def namespaces
    nps = [self]
    nps += namespace.namespaces if namespace.present?
    nps.compact
  end

  def permissions_for(user)
    NamespacePermission.where(user: user, :namespace_id.in => namespaces.pluck(:_id)).pluck(:permissions).flatten.uniq
  end
end
