require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.role_path = 'test/fixtures/roles'
  config.platform = 'ubuntu'
  config.version = '16.04'
  config.log_level = :error
end
