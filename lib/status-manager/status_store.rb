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

		def status?(status)
			@status_sets.key?(status)
		end

		def group_status?(group_status)
			@group_statuses.key?(group_status)
		end

		def statuses
			@status_sets.keys
		end

		def values
			@status_sets.values
		end

		def value(status)
			@status_sets[status]
		end

		def status(value)
			@status_sets.select{ |status, _value| _value == value}.first[0]
		end

		def add_group_status(group_status_name, statuses)
			@group_statuses.merge!({group_status_name => statuses})
		end

		def get_group_status_sets(group_status_name)
			statuses = {}
			@group_statuses[group_status_name].each do |status|
				statuses[status] = self.value(status)
			end
			statuses
		end
	end
end