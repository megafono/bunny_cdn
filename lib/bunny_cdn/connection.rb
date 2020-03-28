require 'forwardable'

module BunnyCDN
  class Connection
    extend Forwardable

    def_delegators :connection, :put, :get, :post, :delete

    def initialize(type)
      @type = type
      @token = Rails.application.config.bunny.tokens[type]
    end

    def connection
      @connection ||= Faraday.new(endpoint, headers: build_headers) do |conn|
        conn.request :json
        conn.response :json, content_type: /\bjson$/
        conn.response :logger

        conn.adapter Faraday.default_adapter
      end
    end

    private

    def endpoint
      @endpoint ||= [
        "https://",
        @type == :storage ? "storage." : nil,
        "bunnycdn.com",
        @type == :storage ? nil : "/api"
      ].compact.join
    end

    def build_headers
      {
        'Content-Type' => 'application/json',
        'AccessKey' => @token
      }
    end
  end
end
