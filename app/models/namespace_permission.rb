class NamespacePermission
  include Mongoid::Document
  include Mongoid::Timestamps

  PERMISSIONS = ["viewer", "creator", "owner"]

  belongs_to :user
  belongs_to :namespace

  field :permissions, type: Array, default: []

  validates :permissions, presence: true
  validates :user_id, presence: true, uniqueness: { scope: [:namespace_id] }

  validate :validate_permissions!

  private

  def validate_permissions!
    unkown_permission = self.permissions - PERMISSIONS
    unless unkown_permission.blank?
      errors.add(:permissions, "#{unkown_permission.join(",")} permissions not permisted")
    end
  end
end
