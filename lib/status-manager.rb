module StatusManager

	def self.included(base)
		base.extend(ClassMethods)
	end

	module ClassMethods
		def attr_as_status (status_title, status={})
			@@status_manager_status_list ||= {}
			puts "double"
			# TODO : initailize every call model
			raise "#{status_title} variable is already exist" if @@status_manager_status_list.key? status_title.to_sym
			@@status_manager_status_list[status_title.to_sym] = {}

			status.each do |key, value|
				#set status
				@@status_manager_status_list[status_title.to_sym][key.to_sym] = value

				#scope setting
				scope "#{status_title}_#{key}", where("#{self.table_name}.#{status_title}" => value)

				#true / false
				define_method "#{status_title}_#{key}?" do
					eval("self.#{status_title} == '#{value}'")
				end

				define_method "#{status_title}_to" do |will_status|
					eval("self.#{status_title} = @@status_manager_status_list[:#{status_title}][will_status]")
				end 

				define_method "update_#{status_title}_#{key}" do
					self.update_attributes(status_title.to_sym => value)
				end
			end

			define_method "update_#{status_title}" do |will_status|
				self.update_attributes(status_title.to_sym => status[will_status.to_sym])
			end

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

ActiveRecord::Base.send(:include, StatusManager) if defined? ActiveRecord
