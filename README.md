## Description
[![Gem Version](https://badge.fury.io/rb/status-manager.svg)](http://badge.fury.io/rb/status-manager)

ActiveRecord Model Status Manager, It provides easy ways managing models that have many statuses.

www.myrealtrip.com uses status-manager

## Usage

### Rails 3.x

```ruby
gem 'status-manager'
```

### Example 

#### Define

```ruby
class Product < ActiveRecord::Base
	attr_accessible :title, :sale_status
  
	attr_as_status :sale_status, 
		[:onsale, :reject, :pending, :soldout], 
		:default => :pending,
		:group => {
			:close => [:reject, :pending],
			:open => [:onsale, :soldout]
		}
	# 1. :default and :group are optional
	# 2. :group element :close and :open work as status
	# 3. If you want to specify status value that save in database, use Hash instead of Array. 
	# 	ex) {:onsale => "ONSALE", :pending => "PENDING" ...} or {:onsale => 1, :pending => 2 ...}
end
```
or
```ruby
class Product < ActiveRecord::Base
	attr_accessible :title, :sale_status
  
  	# attr_as_status :status_attribute in model, {:status_value => 'status_value that is saved in database'}
	attr_as_status :sale_status, {
		:onsale => 'onsale', 
		:reject => 'reject', 
		:pending => 'pending', 
		:soldout => 'soldout'
		}
	status_group :sale_status, {
		:close => [:reject, :pending],  # :close works as status
		:open => [:onsale, :soldout]
		}	
end
```

#### Queries
```ruby
## status_list
Product.sale_statuses #=> {:onsale => 'onsale', :reject => 'reject', :pending => 'pending', :soldout => 'soldout'}

## use scope
@onsale_product = Product.sale_status_onsale.first 
@closed_product = Product.sale_status_close.first
#or using symbol
Product.sale_status(:open)
#or multiple statuses (with group statuses)
Product.sale_status([:soldout, :close]) # use array

@onsale_product.sale_status_onsale? #=> true
#or
@closed_product.sale_status?(:close) #=> true


## change status
@closed_product.sale_status_to(:onsale)
#or
@closed_product.sale_status_to_onsale

## update status
@closed_product.update_sale_status_to(:onsale) 
#or
@closed_product.update_sale_status_to_onsale
```

#### Inspect status changing
```ruby
pending_product = Product.sale_status(:pending).first
pending_product.sale_status_to(:onsale)

pending_product.sale_status_changed? #=> true
pending_product.sale_status_changed?(:from => :pending, :to => :onsale) #=> true
pending_product.sale_status_changed?(:to => :onsale) #=>true
pending_product.sale_status_changed?(:from => :onsale) #=> true
```

#### Callback
``` ruby
class Product < ActiveRecord::Base
	attr_accessible :title, :sale_status
  
  	# attr_as_status :status_attribute in model, {:status_value => 'status_value that is saved in database'}
	attr_as_status :sale_status, 
		[:onsale, :reject, :pending, :soldout], 
		:default => :pending
		:group => {
			close: [:reject, :pending], 
			open: [:onsale, :soldout]
		}
		

	#callback update status from specific status
	before_status_update :sale_status, :onsale => :close do |product|
		product.sale_status_changed?(:from => :onsale, :to => :close) #=> true
		# do somthing
	end

	after_status_update :sale_status, :close => :onsale do |product|
		# do something after update 
	end
	
	#callback update status
	after_status_update :sale_status, :reject do |prdocut|
		product.sale_status_changed? #=> true
		product.sale_status?(:reject) #=> true
		# do something after update
	end
end

```
