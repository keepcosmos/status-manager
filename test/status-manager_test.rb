require 'test_initializer'
require 'models/product'

class StatusManagerTest < Test::Unit::TestCase

	def test_change
		product = Product.sale_status(:onsale).first
		assert !product.sale_status_changed?
		product.sale_status_to(:pending)
		assert product.sale_status_changed?
		assert product.sale_status_changed?(:from => :display, :to => :close)
		assert product.sale_status_changed?(:from => :onsale)
		assert product.sale_status_changed?(:to => :close)
		product.save
		assert !product.sale_status_changed?
	end

	def test_status_update
		product = Product.sale_status(:pending).first
		assert product.sale_status?(:pending)
		product.update_sale_status_to_onsale
		assert product.sale_status?(:onsale)
	end

	def test_multiple_status_scope
		assert Product.sale_status(Product.sale_statuses.keys).size == Product.all.size
		assert Product.sale_status([:display, :reject]).size == (Product.all.size - Product.sale_status(:pending).size)
	end

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

		product.update_sale_status_to :soldout
		assert Product.find(product.id).sale_status_soldout?

		product.update_sale_status_to_onsale
		assert Product.find(product.id).sale_status_onsale?
	end

	def test_group_status
		closed_products = Product.sale_status_close
		_closed_products = Product.sale_status(:close)
		assert closed_products.size == _closed_products.size
		closed_products.each do |product|
			assert product.sale_status_close?
			assert product.sale_status? :close
		end

		displayed_products = Product.sale_status_display
		displayed_products.each do |product|
			assert product.sale_status_display?
			assert product.sale_status? :display
		end
	end

end