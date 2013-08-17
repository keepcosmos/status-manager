module StatusManager
	module StatusUpdateCallback
		def after_status_update(status_title, status_way, &block)
			self.after_update do |obj|
				self.class.send(:status_update_callback, obj, status_title, status_way, &block)
			end
		end

		def before_status_update(status_title, status_way, &block)
			self.before_update do |obj|
				self.class.send(:status_update_callback, obj, status_title, status_way, &block)
			end
		end
		
		def status_update_callback(obj, status_title, status_way, &block)
			if obj.send("#{status_title}_changed?") 
				if status_way.class == Hash
					prev_status = status_way.first[0]
					next_status = status_way.first[1]
					if obj.send("#{status_title}_was_#{prev_status}?") && obj.send("#{status_title}_#{next_status}?")
						block.call(obj)
					end
				elsif status_way.class == Symbol
					if obj.send("#{status_title}_#{status_way}?")
						block.call(obj)
					end
				end
			end
		end
	end
end