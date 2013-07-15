ActiveRecord::Schema.define(:version => 0) do
  create_table :products, :force => true do |t|
    t.column :title,          :string
    t.column :status,         :string
  end
end