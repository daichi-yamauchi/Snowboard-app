require 'capybara/rspec'
require 'rack_session_access/capybara'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions =
      true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  # capyparaをspec/requestsで使えるように設定
  config.include Capybara::DSL, type: :request
  config.include Capybara::RSpecMatchers, type: :request

  # system specのドライバ設定
  config.before(:each, type: :system) do
    driven_by :selenium_chrome_headless
  end
end
