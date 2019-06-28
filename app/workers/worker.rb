module Worker
  extend ActiveSupport::Concern

  included do
    def initialize(arguments)
      @arguments = arguments
    end

    def execute
      perform(arguments)
    end
  end

  class_methods do
    def set_options(options = {})
      @options = options.symbolize_keys
    end

    def options
      @options ||= {}
    end

    def exchange
      options.fetch(:exchange, self.name)
    end

    def queue
      options.fetch(:queue, self.name)
    end

    def queue_retry
      options.fetch(:queue, "#{queue}.retry")
    end

    def queue_dead
      options.fetch(:queue, "#{queue}.dead")
    end

    def max_retries
      options.fetch(:max_retries, 10)
    end

    def enqueue(*arguments)
      client.enqueue({ class_name: name, arguments: arguments })
    end

    def client
      @@client ||= Rabbit.new('DEEP_THOUGHT__RABBITMQ_URI')
    end
  end
end
