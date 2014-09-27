require_relative '../helpling'

if defined?(RSpec)
  RSpec.configure do |config|
    config.include(Helpling::TestHelper, type: :request)
  end
end
