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
	my_status_group :close, [:reject, :pending]
	
end
```

```ruby
# select
@onsale_products = Product.my_status_onsale
@closed_products = Product.my_status_close

assert @onsale_products.first.my_status_onsale?
assert @closed_products.first.my_status_close?

# update
@closed_products.first.my_status_to(:onsale) ## => update just attribute value
@closed_products.first.update_my_status_onsale ## => update with database
