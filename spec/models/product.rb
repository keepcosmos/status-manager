class Product < ActiveRecord::Base
  # acts_as_status :status_attribute in model, {status_value: 'status_value that is saved in database'}

  # attr_as_status :sale_status, onsale: 'onsale', reject: 'reject', pending: 'pending', soldout: 'soldout'
  # attr_as_status :sale_status, [:onsale, :reject, :pending, :soldout]

  attr_as_status :sale_status,
                 [:onsale, :reject, :pending, :soldout],
                 default: :onsale,
                 group: { close: [:pending, :reject],
                          open: [:soldout, :onsale],
                          display: [:onsale, :soldout]
                        }

  before_status_update :sale_status, close: :onsale do |product|
    puts "display #{product.title}"
  end

  after_status_update :sale_status, pending: :onsale do |product|
    puts "release #{product.title}"
  end

  after_status_update :sale_status, :onsale do |product|
    puts "onsale #{product.title}"
  end

  after_status_update :sale_status, display: :close do |product|
    puts "close #{product.title}"
  end
end
