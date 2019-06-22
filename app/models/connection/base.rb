module Connection
  class Base
    include Mongoid::Document
    include Mongoid::Timestamps

    store_in collection: 'connections'
  
    field :name, type: String
  
    validates :name, presence: true, uniqueness: true
  
    def self.create_params
      [:name]
    end
  
    def type
      self.class.name
    end
  end
end
