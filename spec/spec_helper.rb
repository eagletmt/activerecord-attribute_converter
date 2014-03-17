require 'activerecord/attribute_converter'

require 'active_record'
ActiveRecord::Base.configurations['test'] = {
  adapter: 'sqlite3',
  database: ':memory:',
}
ActiveRecord::Base.establish_connection(:test)
require File.expand_path('../schema', __FILE__)
require File.expand_path('../models', __FILE__)

RSpec.configure do |config|
  config.filter_run :focus
  config.filter_run_excluding version: lambda { |v| v != ActiveRecord::VERSION::MAJOR }
  config.run_all_when_everything_filtered = true

  config.order = :random
  Kernel.srand config.seed

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end

  config.after :each do
    Book.delete_all
  end
end
