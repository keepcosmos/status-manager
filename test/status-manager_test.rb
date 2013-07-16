require 'test_initializer'
require 'models/product'

class StatusManagerTest < Test::Unit::TestCase

	def test_sample
		product = Product.status_onsale.first

		product.update_status_reject
		puts product.status
	end

end