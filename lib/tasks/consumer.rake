require "#{Rails.root}/lib/consumer.rb"

namespace :consumer do
  desc "RUN Background consumer job"
  task run: :environment do
    Consumer.new.execute!
  end
end
