module StatusManager
	module StatusGroupManager
		def status_group (status_attribute_name, group_status_set={})
			status_store = self.status_store_list.get(status_attribute_name.to_sym)
			raise "undefined #{status_attribute_name}" unless status_store
			
			group_status_set.each do |group_status_name, group_statuses|
				raise "#{status_attribute_name}-#{group_status_name} is not a group, group must have statuses" if group_statuses.size < 1
				status_store.add_group_status(group_status_name, group_statuses)

				# set scope
				scope "#{status_store.attribute_name}_#{group_status_name}", where("#{self.table_name}.#{status_store.attribute_name} in (?)", status_store.get_group_status(group_status_name).values)

				# status check method
				define_method "#{status_attribute_name}_#{group_status_name}?" do 
					status_store.get_group_status(group_status_name).values.include? self.send(status_attribute_name)
				end

				define_method "#{status_attribute_name}_was_#{group_status_name}?" do
					status_store.get_group_status(group_status_name).values.include? self.send("#{status_attribute_name}_was")
				end
			end
		end
	end
end