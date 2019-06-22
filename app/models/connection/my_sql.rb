module Connection
  class MySQL < Base
    field :host, type: String
    field :port, type: String, default: 3306
    field :username, type: String
    field :password, type: String

    validates_presence_of :host, :port

    def self.create_params
      [:name, :host, :port, :username, :password]
    end
  end
end
