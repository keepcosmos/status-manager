require 'test_initializer'
require 'models/product'

class StatusManagerTest < Test::Unit::TestCase

	def test_current_status
		products = Product.sale_status_onsale
		products.each do |product|
			assert product.sale_status_onsale?
			assert product.sale_status? :onsale
		end

		rejected_products = Product.sale_status_reject
		rejected_products.each do |product|
			assert product.sale_status_reject?
			assert product.sale_status? :reject
		end
	end

	def test_status_update
		product = Product.sale_status_onsale.first
		product.sale_status_to :reject
		product.sale_status_to_reject
		assert product.sale_status_reject?
		assert product.sale_status? :reject

		product.update_sale_status :soldout
		assert Product.find(product.id).sale_status_soldout?

		product.update_sale_status_to_onsale
		assert Product.find(product.id).sale_status_onsale?
	end

	def test_group_status
		closed_products = Product.sale_status_close
		closed_products.each do |product|
			assert product.sale_status_close?
			assert product.sale_status? :close
		end

		opened_products = Product.sale_status_open
		opened_products.each do |product|
			assert product.sale_status_open?
			assert product.sale_status? :open
		end
	end

	# def test_current_status
	# 	product = Product.first
	# 	assert_equal true, product.sale_status_onsale?
	# end

	# def test_status_scope
	# 	products = Product.sale_status_reject
	# 	products.each do |product|
	# 		assert product.sale_status_reject?, "#{product.id} is not rejected product"
	# 	end
	# end

	# def test_status_update
	# 	product = Product.sale_status_reject.first
	# 	product.sale_status_to(:soldout)
	# 	assert product.sale_status_soldout?
	# 	assert product.update_status_to_onsale
	# 	assert product.sale_status_onsale?
	# 	product.update_status(:soldout)
	# 	assert product.sale_status_soldout?
	# end

end