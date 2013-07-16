class Product < ActiveRecord::Base
	attr_accessible :title, :status

	acts_as_status :status, :onsale => 'onsale', :reject => 'reject', :pending => 'pending', :soldout => 'soldout'
	
end
