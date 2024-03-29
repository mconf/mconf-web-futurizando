# This file is part of Mconf-Web, a web application that provides access
# to the Mconf webconferencing system. Copyright (C) 2010-2012 Mconf
#
# This file is licensed under the Affero General Public License version
# 3 or later. See the LICENSE file.

# This file is copied to spec/ when you run 'rails generate rspec:install'

require 'simplecov'
SimpleCov.start if ENV["COVERAGE"]

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'shoulda-matchers'
require 'cancan/matchers'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

ActionMailer::Base.delivery_method = :test
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.deliveries = []
ActionMailer::Base.default_url_options = { :host => 'localhost:3001' }

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # Make the rails routes avaiable in all specs
  #config.include Rails.application.routes.url_helpers

  # we don't ever run migration specs, they should be used individually
  config.filter_run_excluding :migration => true
  config.run_all_when_everything_filtered = true

  # To use old default of rspec 2
  config.infer_spec_type_from_file_location!

  config.include Devise::TestHelpers, :type => :controller
  config.include ControllerMacros, :type => :controller
  config.extend Helpers::ClassMethods

  config.after(:each) do
    if Rails.env.test?
      FileUtils.rm_rf(Dir["#{Rails.root}/spec/support/uploads"])
    end
  end

  config.before(:each) do
    Helpers.setup_site
  end

end

# Note: this was being included directly in the factories that need `fixture_file_upload`, but
# was causing errors in some other tests, so now it's done here. See more at:
# stackoverflow.com/questions/13673639/accessing-session-from-a-helper-spec-in-rspec#answer-13697474
FactoryGirl::SyntaxRunner.class_eval do
  include ActionDispatch::TestProcess
end
