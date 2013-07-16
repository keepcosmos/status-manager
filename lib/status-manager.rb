module StatusManager

	def self.included(base)
		base.extend(ClassMethods)
	end

	module ClassMethods
		def acts_as_status (status_title, status={})
			eval("#{status_title.upcase} = #{status}")

			status.each do |key, value|
				#scope setting
				scope "#{status_title}_#{key}", where(status_title => value)

				#true / false
				define_method "#{status_title}_#{key}?" do
					eval("self.#{status_title} == '#{value}'")
				end

				define_method "update_#{status_title}_#{key}" do
					self.update_attributes(status_title => value)
				end
			end

		end
	end

	module InstanceMethods

	end
end

ActiveRecord::Base.send(:include, StatusManager) if defined? ActiveRecord