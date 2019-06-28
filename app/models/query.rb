class Query
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  belongs_to :user
  belongs_to :connection
  belongs_to :namespace

  field :sql, type: String
  field :variables, type: Hash, default: {}
  field :final_query, type: String
  field :status, type: String, default: "none"
  field :success, type: Mongoid::Boolean
  field :message, type: String

  has_mongoid_attached_file :result, disable_fingerprint: true

  validates :sql, presence: true
  validates :status, presence: true, inclusion: { in: ["none", "enqueued", "running", "done"] }
end
