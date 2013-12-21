module StatusManager
	module StatusUpdateCallback
		def after_status_update(attribute_name, status_way, &block)
			self.after_update do |obj|
				self.class.send(:status_update_callback, obj, attribute_name, status_way, &block)
			end
		end

		def before_status_update(attribute_name, status_way, &block)
			self.before_update do |obj|
				self.class.send(:status_update_callback, obj, attribute_name, status_way, &block)
			end
		end
		
		def status_update_callback(obj, attribute_name, status_way, &block)
			if obj.send("#{attribute_name}_changed?") 
				if status_way.instance_of?(Hash)
					if obj.send("#{attribute_name}_changed?", {:from => status_way.first[0], :to => status_way.first[1]})
						block.call(obj)
					end
				elsif status_way.class == Symbol
					if obj.send("#{attribute_name}_#{status_way}?")
						block.call(obj)
					end
				end
			end
		end
	end
end