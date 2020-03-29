require "test_helper"

class BunnyCDNTest < Minitest::Test
  def setup
    BunnyCDN.configure do |config|
      config.access_key = "1234567key"
      config.storage_access_key = "1234567keyStorage"
    end
  end

  def test_configuration
    assert_equal BunnyCDN.config.access_key, "1234567key"
    assert_equal BunnyCDN.config.storage_access_key, "1234567keyStorage"
  end

  def test_that_it_has_a_version_number
    refute_nil ::BunnyCDN::VERSION
  end

  def test_purge
    stub_request(:post, "https://bunnycdn.com/api/purge")
      .with(query: { url: "https://megafono.host/12345" })
      .and_return(body: nil, status: 200)

    BunnyCDN.purge("https://megafono.host/12345")

    assert_requested :post,
                     "https://bunnycdn.com/api/purge",
                     headers: {
                       "Accept" => "application/json",
                       "AccessKey" => "1234567key",
                       "Content-Type" => "application/json",
                       "User-Agent" => "Faraday v0.17.3"
                     },
                     query: { url: "https://megafono.host/12345" },
                     times: 1
  end

  def test_upload
    stub_request(:put, "https://storage.bunnycdn.com/zone-x/user/121/profile.jpg")
      .and_return(body: nil, status: 200)

    file = Tempfile.open('foo')
    file.write("test")
    file.rewind

    BunnyCDN.upload("zone-x", "user/121/profile.jpg", file.path)

    assert_requested(:put,
                     "https://storage.bunnycdn.com/zone-x/user/121/profile.jpg",
                     headers: {
                       "Accept" => "application/json",
                       "AccessKey" => "1234567keyStorage",
                       "Content-Type" => "application/json",
                       "User-Agent" => "Faraday v0.17.3"
                     },
                     body: "test",
                     times: 1)

    file.close
    file.unlink
  end
end
