# frozen_string_literal: true

require "faraday"

module BunnyCDN
  class Client
    class ParseJSON < Faraday::Middleware
      def call(env)
        @app.call(env).on_complete do |env|
          env[:body] = ::JSON.parse(env[:body], object_class: OpenStruct) if env[:body].length > 0
        end
      end
    end

    def post(path, params = {})
      connection.post(path, encode(params))
    end

    def put(path, &block)
      connection.put(path) do |request|
        yield(request)
      end
    end

    def initialize(config:, type:)
      @config = config
      @type = type
    end

    def connection
      @connection ||= Faraday.new(endpoint) do |f|
        f.headers["Accept"] = "application/json"
        f.headers["Content-Type"] = "application/json"
        f.headers["AccessKey"] = config.access_key_for(@type)
        f.response :json
        f.adapter :net_http
      end
    end

    private

      attr_reader :config

      def encode(params)
        JSON.dump(params.reject { |_, v| v.nil? })
      end

      def endpoint
        @endpoint ||= [
          "https://",
          @type == :storage ? "storage." : nil,
          "bunnycdn.com",
          @type == :storage ? nil : "/api"
        ].compact.join
      end
  end
end

Faraday::Response.register_middleware json: -> { BunnyCDN::Client::ParseJSON }
