ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
#require 'ruby-debug'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec

  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = true

  config.before(:all) do
    (ActiveRecord::Base.connection.tables - %w{schema_migrations}).each do |table_name|
      ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table_name};")
    end
  end
end

