# typed: true
module BunnyCDN
  class Purger
    def self.purge(url)
      new(url).purge
    end

    def initialize(url)
      @connection = BunnyCDN::Connection.new(:default)
      @url = url
    end

    def purge
      params = { url: url }.to_param
      connection.post("purge?#{params}")
    end

    private

    attr_reader :url, :connection
  end
end

