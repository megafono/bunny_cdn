# frozen_string_literal: true


module BunnyCDN
  class Configuration
    attr_accessor :access_key, :storage_access_key

    def access_key_for(type)
      type == :storage ? storage_access_key : access_key
    end
  end
end
