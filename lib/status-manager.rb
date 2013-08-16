module StatusManager

	def self.included(base)
		base.extend(ClassMethods)

	end

	module ClassMethods
		def attr_as_status (status_title, status={})
			@@status_manager_status_list ||= {}
			@@status_manager_status_list[status_title.to_sym] = status

			status.each do |key, value|
				#active_record scope setting
				scope "#{status_title}_#{key}", where("#{self.table_name}.#{status_title}" => value)

				#status check method
				define_method "#{status_title}_#{key}?" do
					eval("self.#{status_title} == '#{value}'")
				end

				#status setter, (do not override active_model default setter)
				define_method "#{status_title}_to" do |next_status|
					eval("self.#{status_title} = @@status_manager_status_list[:#{status_title}][next_status]")
				end 

				#update status
				define_method "update_#{status_title}_to_#{key}" do
					self.update_attributes(status_title.to_sym => value)
				end
			end


			define_method "update_#{status_title}" do |next_status|
				self.update_attributes(status_title.to_sym => status[next_status.to_sym])
			end

			StatusManager::StatusGroupManager.define_status_group_method(status_title)
		end
	end
end

ActiveRecord::Base.send(:include, StatusManager) if defined? ActiveRecord
