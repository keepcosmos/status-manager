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
		def attr_as_status (status_attribute, statuses={})
			status_store_list[status_attribute] = statuses

			scope "#{status_attribute}", lambda{ | key | where("#{self.table_name}.#{status_attribute}" => status_store_list[status_attribute][key])}

			statuses.each do |key, value|
				#active_record scope setting
				scope "#{status_attribute}_#{key}", where("#{self.table_name}.#{status_attribute}" => value)

				#status check method
				define_method "#{status_attribute}_#{key}?" do 
					self.send("#{status_attribute}") == value
				end

				define_method "#{status_attribute}_was_#{key}?" do 
					self.send("#{status_attribute}_was") == value
				end

				#update status
				define_method "update_#{status_attribute}_to_#{key}" do 
					self.update_attributes("#{status_attribute}" => "#{value}")
				end

				define_method "#{status_attribute}_to_#{key}" do 
					self.send("#{status_attribute}=", value)
				end
			end

			#status check method
			define_method "#{status_attribute}?" do |status|
				self.send("#{status_attribute}_#{status}?")
			end

			define_method "#{status_attribute}_was?" do |status|
				self.send("#{status_attribute}_was_#{status}?")
			end

			#status setter (do not override attr_accessible)
			define_method "#{status_attribute}_to" do |next_status|
				status_value = self.class.status_store_list[status_attribute][next_status]
				self.send("#{status_attribute}=", status_value)
			end

			# update status
			define_method "update_#{status_attribute}_to" do |next_status|
				self.update_attributes(status_attribute.to_sym => self.class.status_store_list[status_attribute][next_status])
			end

			#get status list
			define_singleton_method "#{status_attribute.to_s.pluralize}" do
				self.status_store_list[status_attribute.to_sym]
			end
		end

		def status_store_list
			if self.class_variable_defined?(:@@status_store_list)
				self.class_variable_get(:@@status_store_list)
			else
				self.class_variable_set(:@@status_store_list, {})
			end
		end


	end
end

ActiveRecord::Base.send(:include, StatusManager) if defined? ActiveRecord
