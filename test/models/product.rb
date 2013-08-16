class Product < ActiveRecord::Base
	attr_accessible :title, :sale_status

	# acts_as_status :status_attribute in model, {:status_value => 'status_value that is saved in database'}
	attr_as_status :sale_status, :onsale => 'onsale', :reject => 'reject', :pending => 'pending', :soldout => 'soldout'
	status_group :sale_status, :close => [:reject, :pending], :open => [:onsale, :soldout]
	
	
end
