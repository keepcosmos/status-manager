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
		def attr_as_status(status_attribute, status_sets, options={})
			register_status_sets(status_attribute, status_sets)
			status_group(status_attribute, options[:group]) if options.key?(:group)
			set_default_status(status_attribute, options[:default]) if options.key?(:default)
		end

		def register_status_sets(status_attribute, status_sets, default_status=nil)
			# if status_sets parameter is array.
			# ex) register_status_sets(status, [:onsale, :soldout, :reject])
			raise "Not defined statuses" if status_sets.empty?
			if status_sets.instance_of?(Array)
				raise Exception, "#{status_attribute} column type must be :string or :text in this case, if you want to specify column value use Hash class" unless [:string, :text].include?(self.columns_hash[status_attribute.to_s].type)
				_status_sets = {}
				status_sets.each { |status_set| _status_sets[status_set] = status_set.to_s }
				status_sets = _status_sets
			end

			status_store = StatusStore.new(status_attribute, status_sets)
			status_store_list.add(status_store)

			scope "#{status_store.attribute_name}", lambda{ | statuses | where("#{self.table_name}.#{status_store.attribute_name.to_s}" => status_store.values(statuses)) }

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
				raise "#{status} is undefined status or it is group status" unless status_store.status?(status)
				status_value = self.class.status_store_list.get(status_store.attribute_name).value(status)
				self.send("#{status_store.attribute_name}=", status_value)
			end

			# update status
			define_method "update_#{status_store.attribute_name}_to" do |status|
				raise "#{status} is undefined status or it is group status" unless status_store.status?(status)
				self.update_attributes(status_attribute.to_sym => self.class.status_store_list.get(status_store.attribute_name).value(status))
			end

			define_method("#{status_store.attribute_name}_changed?") do |options={}|
				statuses = self.send("#{status_store.attribute_name}_change")
				if statuses
					if statuses[0] == statuses[1]
						return false
					elsif options[:from] && options[:to]
						self.send("#{status_store.attribute_name}_was?", options[:from]) && self.send("#{status_store.attribute_name}?", options[:to])
					elsif options[:to]
						self.send("#{status_store.attribute_name}?", options[:to])
					elsif options[:from]
						self.send("#{status_store.attribute_name}_was?", options[:from])
					else
						return true
					end
				else
					return false
				end
			end

			#get status list
			define_singleton_method "#{status_store.attribute_name.to_s.pluralize}" do
				self.status_store_list.get(status_store.attribute_name).status_sets
			end
		end

		def set_default_status(status_attribute, status)
			before_create do |obj|
				obj.send("#{status_attribute.to_s}=", obj.class.send(status_attribute.to_s.pluralize)[status]) unless obj.send(status_attribute.to_s)
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