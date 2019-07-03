class Rabbit
  attr_reader :connection

  def initialize(uri)
    @exchanges = {}
    @connection = Bunny.new(uri)
    @connection.start
  end

  def channel
    @channel ||= connection.create_channel
  end

  def enqueue(queue_name, message)
    exchange(queue_name).publish(message)
  end

  def exchange(queue_name)
    return @exchanges[queue_name] if @exchanges[queue_name].present?
    @exchanges[queue_name] = channel.exchange(queue_name, durable: true)
    @exchanges[queue_name]
  end

  def self.instance
    @@instance ||= Rabbit.new(ENV['DEEP_THOUGHT__JOB__RABBIT_URI'])
  end
end
