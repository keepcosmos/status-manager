module StatusManager
	module StatusGroupManager
		def status_group (status_attribute, group_status_set={})
			raise "undefined #{status_attribute}" unless self.status_store_list.key? status_attribute.to_sym
			
			group_status_set.each do |group_status_name, group_statuses|
				group_status_values = []
				group_statuses.each do |status|
					group_status_values << self.status_store_list[status_attribute][status]
				end

				# set scope
				scope "#{status_attribute}_#{group_status_name}", where("#{self.table_name}.#{status_attribute} in (?)", group_status_values)

				# status check method
				define_method "#{status_attribute}_#{group_status_name}?" do 
					group_status_values.include? self.send(status_attribute)
				end

				define_method "#{status_attribute}_was_#{group_status_name}?" do
					group_status_values.include? self.send("#{status_attribute}_was")
				end
			end
		end
	end
end