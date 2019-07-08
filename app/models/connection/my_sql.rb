module Connection
  class MySQL < Base
    field :host, type: String
    field :port, type: Integer, default: 3306
    field :username, type: String
    field :password, type: String
    field :database, type: String

    validates_presence_of :host, :port, :database

    def as_json(options={})
      super(options.merge(except: [:password], methods: [:type]))
    end

    def self.create_params
      {
        name: {
          type: "string",
          required: true
        },
        host: {
          type: "string",
          required: true
        },
        port: {
          type: "interger",
          required: true,
          default: 3306
        },
        username: {
          type: "string"
        },
        password: {
          type: "string"
        },
        database: {
          type: "string",
          required: true
        }
      }
    end

    def client
      @client ||= Connection::Adapter::MySQL.new({ host: host, port: port, username: username, password: password, database: database })
    end
  end
end
