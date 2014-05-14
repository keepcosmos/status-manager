require 'spec_helper'
require 'models/product'

describe StatusManager do

	it "should set default status" do
		product = Product.new
		product.save
		product.should be_sale_status(:onsale)
	end

	it "should check chages with hash" do
		product = Product.sale_status(:onsale).first
		product.should_not be_sale_status_changed
		product.sale_status_to(:pending)
		product.should be_sale_status_changed
		product.should be_sale_status_changed(:from => :display, :to => :close)
		product.should be_sale_status_changed(:from => :onsale)
		product.should be_sale_status_changed(:to => :close)

		product.save
		product.should_not be_sale_status_changed
	end

	it "should update status" do
		product = Product.sale_status(:pending).first
		product.should be_sale_status(:pending)
		product.update_sale_status_to_onsale
		product.should be_sale_status(:onsale)
	end

	it "should work with scope" do
		Product.sale_status([:display, :reject]).size.should equal(Product.all.size - Product.sale_status(:pending).size)
	end

	it "should check current status" do
		products = Product.sale_status_onsale
		products.each do |product|
			product.should be_sale_status_onsale
			product.should be_sale_status(:onsale)
		end

		rejected_products = Product.sale_status_reject
		rejected_products.each do |product|
			product.should be_sale_status_reject
			product.should be_sale_status(:reject)
		end

	end

	it "should update status" do 
		product = Product.sale_status_onsale.first
		product.sale_status_to(:reject)
		product.should be_sale_status(:reject)

		product.update_sale_status_to(:soldout)
		Product.find(product.id).should be_sale_status(:soldout)

		product.update_sale_status_to(:onsale)
		Product.find(product.id).should be_sale_status(:onsale)
	end

	it "should work with status group" do
		closed_products = Product.sale_status_close
		_closed_products = Product.sale_status(:close)
		closed_products.size.should equal(_closed_products.size)
		closed_products.each do |product|
			product.should be_sale_status(:close)
		end

		displayed_products = Product.sale_status_display
		displayed_products.each do |product|
			product.should be_sale_status(:display)
		end
	end

end