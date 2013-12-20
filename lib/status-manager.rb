require 'status-manager/status_group_manager'
require 'status-manager/status_update_callback'
require 'status-manager/status_validation'
require 'status-manager/status_store'
require 'active_support/inflector'

module StatusManager

	def self.included(base)
		base.extend ClassMethods
		base.extend StatusManager::StatusGroupManager
		base.extend StatusManager::StatusUpdateCallback
		base.extend StatusManager::StatusValidation
	end

	module ClassMethods
		def attr_as_status (status_attribute, status_sets={})
			status_store = StatusStore.new(status_attribute, status_sets)
			status_store_list.add(status_store)

			scope "#{status_store.attribute_name}", lambda{ | status |
				if status_store.status?(status)
					where("#{self.table_name}.#{status_store.attribute_name.to_s}" => status_store_list.get(status_store.attribute_name).value(status))
				elsif status_store.group_status?(status)
					where("#{self.table_name}.#{status_store.attribute_name} in (?)", status_store.get_group_status_sets(status).values)
				end
			}

			status_store.status_sets.each do |key, value|
				#active_record scope setting
				scope "#{status_store.attribute_name}_#{key}", where("#{self.table_name}.#{status_store.attribute_name}" => value)

				#status check method
				define_method "#{status_store.attribute_name}_#{key}?" do 
					self.send("#{status_store.attribute_name}") == value
				end

				define_method "#{status_store.attribute_name}_was_#{key}?" do 
					self.send("#{status_store.attribute_name}_was") == value
				end

				#update status
				define_method "update_#{status_store.attribute_name}_to_#{key}" do 
					self.update_attributes("#{status_store.attribute_name}" => "#{value}")
				end

				define_method "#{status_store.attribute_name}_to_#{key}" do 
					self.send("#{status_store.attribute_name}=", value)
				end
			end

			#status check method
			define_method "#{status_store.attribute_name}?" do |status|
				self.send("#{status_store.attribute_name}_#{status}?")
			end

			define_method "#{status_store.attribute_name}_was?" do |status|
				self.send("#{status_store.attribute_name}_was_#{status}?")
			end

			#status setter (do not override attr_accessible)
			define_method "#{status_store.attribute_name}_to" do |status|
				status_value = self.class.status_store_list.get(status_store.attribute_name).value(status)
				self.send("#{status_store.attribute_name}=", status_value)
			end

			# update status
			define_method "update_#{status_store.attribute_name}_to" do |status|
				self.update_attributes(status_attribute.to_sym => self.class.status_store_list.get(status_store.attribute_name).value(status))
			end

			#get status list
			define_singleton_method "#{status_store.attribute_name.to_s.pluralize}" do
				self.class.status_store_list.get(status_attribute).status_sets
			end
		end

		def status_store_list
			if self.class_variable_defined?(:@@status_store_list)
				self.class_variable_get(:@@status_store_list)
			else
				self.class_variable_set(:@@status_store_list, StatusStoreList.new)
			end
		end


	end
end

ActiveRecord::Base.send(:include, StatusManager) if defined? ActiveRecord