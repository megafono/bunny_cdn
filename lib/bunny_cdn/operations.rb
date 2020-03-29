module BunnyCDN
  module Operations
    def purge(url)
      client(:default).post("purge?url=#{url}")
    end

    def upload(zone_name, file_name, path)
      response = client(:storage).put("/#{zone_name}/#{file_name}") do |request|
        request.body = File.binread(path)
      end

      response.success?
    end
  end
end
