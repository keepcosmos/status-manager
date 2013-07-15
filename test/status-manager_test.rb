require 'test_initializer'
require 'status-manager'
require 'test/unit'

class StatusManagerTest < Test::Unit::TestCase
	
	
	def test_sample
		assert_equal StatusManager.hi, "Hello"
	end

end