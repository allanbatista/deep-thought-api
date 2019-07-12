class Job::Query < Job
  include Mongoid::Paperclip

  belongs_to :connection, :class_name => 'Connection::Base'

  field :query, type: String
  field :variables, type: Hash, default: {}
  field :final_query, type: String

  has_mongoid_attached_file :result

  validates_presence_of :query

  def execute!
    self.final_query = Connection::QueryFormater.format(query, variables)

    connection.client.execute(final_query) do |result|
      result.to_tsv("#{id}.tsv")
    end

    self.result = File.open("#{id}.tsv")
    self.save
  end
end
