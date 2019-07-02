class Job
  include Mongoid::Document
  include Mongoid::Timestamps

  after_create :enqueue!

  belongs_to :user
  belongs_to :namespace
  
  field :started_at, type: DateTime
  field :finished_at, type: DateTime
  field :attempt_at, type: DateTime
  field :duration, type: Float
  field :status, type: String, default: "none"
  field :success, type: Mongoid::Boolean
  field :messages, type: Array, default: []
  field :attempts, type: Integer, default: 1

  validates :status, presence: true, inclusion: { in: ["none", "enqueued", "retry", "running", "done"] }

  def execute!
    puts "Job #{id} executed. :)"
  end

  def start!
    update_attributes!(started_at: DateTime.now, status: "running")
  end

  def success!
    finished_at = DateTime.now
    update_attributes!(finished_at: finished_at, status: "done", success: true, duration: (finished_at.to_time - started_at.to_time).round(2))
  end

  def retry!(message)
    messages << message
    attempt_at = DateTime.now
    update_attributes!(attempt_at: attempt_at, status: "retry", duration: (attempt_at.to_time - started_at.to_time).round(2), messages: messages)
  end

  def fail!(message)
    messages < message
    finished_at = DateTime.now
    update_attributes!(finished_at: finished_at, status: "done", success: false, duration: (finished_at.to_time - started_at.to_time).round(2), messages: messages)
  end

  protected

  def enqueue!
    client.enqueue(self.id.to_s)
  end
end
