status-manager
==============

## Description
ActiveRecord Model Status Manager, It provides easy ways managing model that have many statuses.

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
  
  	# attr_as_status :status_attribute in model, {:status_value => 'status_value that is saved in database'}
	attr_as_status :sale_status, {:onsale => 'onsale', :reject => 'reject', :pending => 'pending', :soldout => 'soldout'}
	status_group :sale_status, {:close => [:reject, :pending], :open => [:onsale, :soldout]}
	
end
```

#### Queries
```ruby
## status_list
Product.sale_statuses #=> {:onsale => 'onsale', :reject => 'reject', :pending => 'pending', :soldout => 'soldout'}

## use scope
@onsale_product = Product.sale_status_onsale.first # or Product.sale_status(:onsale).first
@closed_product = Product.sale_status_close.first

@onsale_product.sale_status_onsale? #=> true
#or
@closed_product.sale_status?(:close) #=> true

## change attribute value
@closed_product.sale_status_to(:onsale)
#or
@closed_product.sale_Status_to_onsale

## update value with database
@closed_product.update_sale_status_to(:onsale) 
#or
@closed_product.update_sale_status_to_onsale
```

#### Callback
``` ruby
class Product < ActiveRecord::Base
	attr_accessible :title, :sale_status
  
  	# attr_as_status :status_attribute in model, {:status_value => 'status_value that is saved in database'}
	attr_as_status :sale_status, :onsale => 'onsale', :reject => 'reject', :pending => 'pending', :soldout => 'soldout'
	status_group :sale_status, :close => [:reject, :pending], :open => [:onsale, :soldout]

	#callback update status from specific status
	before_status_update :sale_status, :onsale => :close do |product|
		puts "#{product.title} is closed"
	end

	after_status_update :sale_status, :close => :onsale do |product|
		puts "closed #{product.title} is opened"
		# do something after update 
	end
	
	#callback update status
	after_status_update :sale_status, :reject do |prdocut|
		puts "#{product.title} is rejected"
		# do something after update
	end
end

```


www.myrealtrip.com use status-manager
