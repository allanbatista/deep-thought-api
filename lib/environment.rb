require 'erb'
require 'yaml'

class Environment
  attr_reader :env, :data

  def initialize(filepath, env)
    @env = env
    @data = YAML.load(ERB.new(File.read(filepath)).result)[Rails.env]
  end

  def envs
    @envs ||= @data.each do |key, value|
      @data[key] = ENV.fetch(key, value.to_s)
    end
  end
end