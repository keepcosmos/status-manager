require 'rubygems'
require 'active_record'
require 'active_record/fixtures'
require 'status-manager'
require 'simplecov'

lib = File.expand_path(__dir__)
ActiveRecord::Base.configurations = YAML::load_file("#{lib}/config/database.yml")['test']
ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations)
load("#{lib}/config/schema.rb")

ActiveRecord::Fixtures.create_fixtures 'spec/fixtures', 'products'

RSpec.configure do |config|

end

SimpleCov.start