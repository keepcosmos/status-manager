status-manager
==============

## Description
Simple ActiveRecord Model Status Manager

## Usage

### Rails 3.x

```ruby
gem 'status-manager'
```

### Define Model 

```ruby
class Product < ActiveRecord::Base
	attr_accessible :title, :status
  
  	# acts_as_status :status_attribute in model, {:status_value => 'status_value that is saved in database'}
	acts_as_status :status, :onsale => 'onsale', :reject => 'reject', :pending => 'pending', :soldout => 'soldout'
	status_group :close, [:reject, :pending]
	
end
```

```ruby
# select
@onsale_products = Product.status_onsale
@closed_products = Product.status_close

assert @onsale_products.first.status_onsale?
assert @closed_products.first.status_close?

# update
@closed_products.first.status_to(:onsale) ## => update just attribute value
@closed_products.first.update_status_onsale ## => update with database
