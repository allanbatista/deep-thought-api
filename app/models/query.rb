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

  after_create :enqueue_executor!

  def start!
    update_attributes!(started_at: DateTime.now, status: "running")
  end

  def finish_with_success!(result)
    update_attributes!(finished_at: DateTime.now, status: "done", result: result, success: true)
  end

  def finish_with_error!(message)
    update_attributes!(finished_at: DateTime.now, status: "done", message: message, success: false)
  end

  private

  def enqueue_executor!
    QueryExecutorWorker.enqueue(id.to_s)
  end
end
