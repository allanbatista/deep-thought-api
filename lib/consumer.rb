class Consumer
  def execute!
    Rails.logger.info("Start rabbit connection")
    @connection = Bunny.new(ENV['DEEP_THOUGHT__JOB__RABBIT_URI'])
    @connection.start

    Rails.logger.info("Create rabbit channel")
    channel = @connection.create_channel(nil, concurrency)
    channel.prefetch(concurrency)

    Rails.logger.info("Create rabbit queue")  
    exchange = channel.exchange(queue_name, durable: true)
    queue = channel.queue(queue_name, durable: true, arguments: {'x-dead-letter-exchange' => "#{queue_name}.retry"})
    queue.bind(exchange)

    Rails.logger.info("Create rabbit retry queue")
    exchange_retry = channel.exchange("#{queue_name}.retry", durable: true)
    queue_retry = channel.queue("#{queue_name}.retry", durable: true, arguments: {'x-dead-letter-exchange' => queue_name, 'x-message-ttl': message_retry_ttl})
    queue_retry.bind(exchange_retry)

    Rails.logger.info("Create rabbit dead letter queue")
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
    @consumer = queue.subscribe(manual_ack: true) do |delivery_info, properties, job_id|
      break if stop?

      begin
        job = Job.find(job_id)

        if job.present?
          job.start!
          job.execute!
          job.success!
        else
          Rails.logger.info("[#{job_id}] job not found")
        end

        channel.ack(delivery_info.delivery_tag)
        Rails.logger.info("[#{job_id}] success!")
      rescue => e
        if should_retry?(properties)
          channel.reject(delivery_info.delivery_tag)
          if job.present?
            job.retry!(e.to_s)

            Rails.logger.info("[#{job_id}][retry] #{e.to_s}")
          end
        else
          queue_dead.publish(job_id)
          channel.ack(delivery_info.delivery_tag)
          if job.present?
            job.fail!(e.to_s)
            Rails.logger.info("[#{job_id}][fail] #{e.to_s}")
          end
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
    puts e
    raise e
  ensure
    Rails.logger.info("stop consumer")
    @consumer.cancel rescue nil
    @connection.close rescue nil
  end

  def should_retry?(properties)
    count = properties[:headers]["x-death"].first["count"].to_i rescue 0
    count < max_retries
  end

  def max_retries
    [1, ENV['DEEP_THOUGHT__JOB__MAX_RETRIES'].to_i].max
  end

  def concurrency
    [1, ENV['DEEP_THOUGHT__JOB__CONCURRENCY'].to_i].max
  end

  def message_retry_ttl
    ENV['DEEP_THOUGHT__JOB__RETRY_TTL'].to_i
  end

  def stop!
    Rails.logger.info("Waiting for Stop")
    @stop = true
  end

  def stop?
    @stop == true
  end

  def queue_name
    @queue_name ||= ENV['DEEP_THOUGHT__JOB__QUEUE_NAME']
  end

  def sleep_time
    @sleep_time ||= ENV['DEEP_THOUGHT__JOB__SLEEP_TIME'].to_f
  end
end
