class Namespace
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :namespace, optional: true

  field :name, type: String

  validates :name, presence: true, uniqueness: true
end
