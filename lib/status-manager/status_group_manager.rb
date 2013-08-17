module StatusManager
	module StatusGroupManager
		def status_group (status_title, group_status_list={})
			raise "undefined #{status_title}" unless self.manager_status_list.key? status_title.to_sym
			
			group_status_list.each do |group_status_title, group_statuses|
				group_status_values = []
				group_statuses.each do |status|
					group_status_values << self.manager_status_list[status_title][status]
				end

				# set scope
				scope "#{status_title}_#{group_status_title}", where("#{self.table_name}.#{status_title} in (?)", group_status_values)

				# status check method
				define_method "#{status_title}_#{group_status_title}?" do 
					group_status_values.include? self.send(status_title)
				end

				define_method "#{status_title}_was_#{group_status_title}?" do
					group_status_values.include? self.send("#{status_title}_was")
				end
			end
		end
	end
end