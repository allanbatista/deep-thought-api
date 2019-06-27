module Connection
  class Base
    include Mongoid::Document
    include Mongoid::Timestamps

    store_in collection: 'connections'
    belongs_to :namespace, optional: true

    field :name, type: String
  
    validates :name, presence: true, uniqueness: true
    validate :skip_base_connection!

    def self.permit_params
      create_params.keys + [:namespace_id]
    end
    
    # :nocov:
    def self.create_params
      {
        name: {
          type: "string",
          required: true
        }
      }
    end
    # :nocov:

    def self.type
      name.split("::").last
    end
  
    def type
      self.class.type
    end

    private

    def skip_base_connection!
      if self.type == "Base"
        errors.add(:type, "not permite create a base connection.")
      end
    end
  end
end
