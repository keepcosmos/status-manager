module StatusManager
	module StatusGroupManager
		def define_status_group_method (status_title)
			define_singleton_method "#{status_title}_group" do |group_title, status_list|
				all_status = @@status_manager_status_list[status_title.to_sym]
				group_status_values = []

				status_list.each do |key|
					group_status_values << all_status[key.to_sym]
					raise "#{group_title} : #{key} is not a #{status_title} member" unless all_status.include? key
				end

				scope "#{status_title}_#{group_title}", where("#{self.table_name}.#{status_title} in (:status)", :status => group_status_values)

				define_method "#{status_title}_#{group_title}?" do
					group_status_values.include? self.send(status_title.to_sym)
				end
			end
		end
	end
end