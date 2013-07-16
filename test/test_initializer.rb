$:.unshift(File.dirname(__FILE__) + '/../..')
$:.unshift(File.dirname(__FILE__) + '/../../lib')

require 'rubygems'
require 'test/unit'
require 'active_record'
require 'active_record/fixtures'

require 'status-manager'

ActiveRecord::Base.configurations = YAML::load_file("#{File.dirname(__FILE__)}/config/database.yml")['test']
ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations)
load("#{File.dirname(__FILE__)}/config/schema.rb")

ActiveRecord::Fixtures.create_fixtures 'test/fixtures', 'products'