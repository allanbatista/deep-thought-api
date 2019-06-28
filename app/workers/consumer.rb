class Consumer
  attr_reader :options
  
  def initialize(options = {})
    @options = options || {}
  end

  def execute
    Rails.logger.info("Start rabbit connection")
    connection = Bunny.new(ENV['BIGDATA__FEEDS__CONSUMER_RABBITMQ_URI'])
    connection.start
    
    Rails.logger.info("Create rabbit channel")
    channel = connection.create_channel(nil, concurrency)
    channel.prefetch(concurrency)

    # exchange and queue for current worker
    exchange = channel.exchange(queue_name, durable: true)
    queue = channel.queue(queue_name, durable: true, arguments: queue_arguments.merge('x-dead-letter-exchange' => "#{queue_name}.retry"))
    queue.bind(exchange)
    
    # exchange and queue for retry
    exchange_retry = channel.exchange("#{queue_name}.retry", durable: true)
    queue_retry = channel.queue("#{queue_name}.retry", durable: true, arguments: {'x-dead-letter-exchange' => queue_name, 'x-message-ttl': message_retry_ttl})
    queue_retry.bind(exchange_retry)
    
    # dead queue
    queue_dead = channel.queue("#{queue_name}.dead", durable: true)

    Signal.trap('INT') do
      if stop?
        puts "force stop! :("
        exit
      else
        puts "stopping gracely. wait please. :)"
        stop!
      end
    end
    
    Rails.logger.info("Start consumer")
    @consumer = queue.subscribe(manual_ack: true) do |delivery_info, properties, payload|
      break if stop?
      
      start_time = Time.now

      begin
        yield(payload) if payload.to_s.strip.present?
        channel.ack(delivery_info.delivery_tag)
        
        Rails.logger.info({ elapse_ms: time_diff_milli(start_time, Time.now), label: :ack })
      rescue HttpException::Server => e
        channel.reject(delivery_info.delivery_tag)
        log_error(e, { elapse_ms: time_diff_milli(start_time, Time.now), label: :reject, payload: payload.ensure_utf_8 })
      rescue => e
        if should_retry?(properties)
          channel.reject(delivery_info.delivery_tag)
          log_error(e, { elapse_ms: time_diff_milli(start_time, Time.now), label: :reject, payload: payload.ensure_utf_8 })
        else
          queue_dead.publish(payload)
          channel.ack(delivery_info.delivery_tag)
          log_error(e, { elapse_ms: time_diff_milli(start_time, Time.now), label: :dead, payload: payload.ensure_utf_8 })
        end
      end
    end

    # wait for messages
    loop do
      if stop?
        @consumer.cancel
        break
      end
      
      sleep(sleep_time)
    end
  rescue => e
    log_error(e)
    raise e
  ensure
    Rails.logger.info("stop consumer")
    @consumer.cancel
  end

  def should_retry?(properties)
    count = properties[:headers]["x-death"].first["count"].to_i rescue 0
    count < max_retries
  end

  def max_retries
    [1, ENV['BIGDATA__FEEDS__CONSUMER_MAX_RETRIES'].to_i].max
  end

  def concurrency
    [1, ENV['BIGDATA__FEEDS__CONSUMER_CONCURRENCY'].to_i].max
  end

  def message_retry_ttl
    ENV['BIGDATA__FEEDS__CONSUMER_RETRY_TTL'].to_i
  end

  def stop!
    Rails.logger.info("Waiting for Stop")
    @stop = true
  end

  def stop?
    @stop == true
  end

  def queue_name
    @queue_name ||= @options["queue_name"]
  end

  def sleep_time
    @sleep_time ||= @options["sleep_time"] || 0.2
  end

  def queue_arguments
    @queue_arguments ||= @options["queue_arguments"] || {}
  end

  def batch_size
    @options['batch_size']
  end

  def log_error(exception, arguments={})
    if exception.respond_to?(:to_h)
      Rails.logger.error(exception.to_h.merge({
        arguments: arguments
      }))
    else
      Rails.logger.error({
        exception: exception.to_s,
        backtrace: exception.backtrace.join("\n"),
        arguments: arguments
      })
    end
  end

  private

  def time_diff_milli(start, finish)
    ((finish - start) * 1000.0).round(4)
  end
end
