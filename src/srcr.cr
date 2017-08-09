require "./srcr/*"
require "http/client"

module SRcr
  USER_AGENT = "SRcr/" + SRcr::VERSION
  API_ROOT = "https://www.speedrun.com/api/v1/"
  CLIENT = HTTP::Client.new(URI.parse API_ROOT)
end
