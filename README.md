status-manager
==============

## Description
Simple ActiveRecord Model Status Manager

## Usage

### Rails 3.x

```ruby
gem 'status-manager'
```

### Example 

```ruby
class Product < ActiveRecord::Base
	attr_accessible :title, :my_status
  
  	# attr_as_status :status_attribute in model, {:status_value => 'status_value that is saved in database'}
	attr_as_status :my_status, :onsale => 'onsale', :reject => 'reject', :pending => 'pending', :soldout => 'soldout'
	status_group :my_status, :close => [:reject, :pending], :open => [:onsale, :soldout]
	
end
```

```ruby
## select
@onsale_product = Product.my_status_onsale.first
@closed_product = Product.my_status_close.first

@onsale_product.my_status_onsale? #=> true
#or
@closed_product.my_status?(:close) #=> true

## update just attribute value
@closed_product.my_status_to(:onsale)
#or
@closed_product.my_Status_to_onsale

## update with database
@closed_product.update_my_status(:onsale) 
#or
@closed_product.update_my_status_onsale


