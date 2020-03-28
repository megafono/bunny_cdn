# typed: true
module BunnyCDN
  class Uploader
    def initialize(zone_name, file_name)
      @connection = BunnyCDN::Connection.new(:storage)
      @zone_name = zone_name
      @file_name = file_name
    end

    def upload(path)
      response = @connection.put("/#{zone_name}/#{file_name}") do |request|
        request.body = File.binread(path)
      end

      response.success?
    end

    private

    attr_reader :zone_name, :file_name
  end
end
