require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect("bunny_cdn"   => "BunnyCDN")
loader.setup

module BunnyCDN
end
