module StatusManager
	class StatusStoreList
		attr_accessor :status_stores

		def initialize
			@status_stores = []
		end

		def add(status_store)
			@status_stores << status_store
		end

		def get(attribute)
			@status_stores.select {|status_store| status_store.attribute_name == attribute}.first
		end
	end

	class StatusStore
		attr_accessor :attribute_name, :status_sets, :group_statuses

		def initialize(attribute_name, status_sets=nil )
			@attribute_name = attribute_name
			@status_sets = status_sets || {}
			@group_statuses = {}
		end

		def statuses
			@status_sets.keys
		end

		def status?(status)
			@status_sets.key?(status)
		end

		def value(status)
			@status_sets[status]
		end

		def group_status?(group_status)
			@group_statuses.key?(group_status)
		end

		#scope에 array 파라미터 넣기 적용
		def values(statuses=[])
			if statuses.nil?
				return @statuse_sets.values
			elsif status? statuses
				return [value(statuses)]
			elsif group_status? statuses
				return get_group_status(statuses).values
			elsif statuses.instance_of?(Array)
				results = []
				statuses.each do |_status|
					if status?(_status)
						results << value(_status)
					elsif group_status?(_status)
						results |= get_group_status(_status).values
					end
				end
				return results.uniq
			else
				return []
			end
		end

		def add_group_status(group_status_name, statuses)
			@group_statuses.merge!({group_status_name => statuses})
		end

		def get_group_status(group_status_name)
			statuses = {}
			@group_statuses[group_status_name].each do |status|
				statuses[status] = self.value(status)
			end
			statuses
		end
	end
end