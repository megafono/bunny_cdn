# frozen_string_literal: true

require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect("bunny_cdn" => "BunnyCDN")
loader.setup

module BunnyCDN
  extend Operations

  class << self
    def client(type)
      @client ||= {}
      @client[type] ||= Client.new(config: config, type: type)
    end

    def configure
      yield config
    end

    def config
      @config ||= Configuration.new
    end
  end
end
