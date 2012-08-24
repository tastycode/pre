require_relative "../lib/pre"
require_relative "../lib/pre/fake_validation"
require_relative "../lib/pre/cache_store/fake"

RSpec.configure do |config|
  config.mock_framework = :mocha
end
