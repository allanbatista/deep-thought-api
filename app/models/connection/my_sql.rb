module Connection
  class MySQL < Base
    field :host, type: String
    field :port, type: Integer, default: 3306
    field :username, type: String
    field :password, type: String

    validates_presence_of :host, :port

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
        }
      }
    end
  end
end
