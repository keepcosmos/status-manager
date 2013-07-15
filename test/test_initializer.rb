require 'active_support'
require 'active_record'
require 'active_record/fixtures'

ActiveRecord::Base.establish_connection(YAML::load_file("#{File.dirname(__FILE__)}/config/database.yml")['test'])
load("#{File.dirname(__FILE__)}/config/schema.rb")

