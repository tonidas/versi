require "bundler/setup"
Bundler.setup

require "byebug"
require "versi"

RSpec.configure do |config|
  Versi::LOG = Logger.new(nil)
end
