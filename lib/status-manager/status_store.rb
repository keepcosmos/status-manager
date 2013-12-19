module StatusManager
	class StatusStoreList
		attr_accessor :status_store

		def initialize
			@status_store = []
		end

		def add_status_store(status_store)
			@status_store << status_store
		end

		def status_store(status_attribute)
			@status_store.select {|status_store| status_store.status_attribute == status_attribute}.first
		end
	end

	class StatusStore
		attr_accessor :status_attribute, :status_sets, :group_statuses

		def initialize(status_attribute, status_sets=nil )
			@status_attribute = status_attribute
			@status_sets = status_sets || {}
			@group_statuses = []
		end

		def status?(status)
			@status_sets.key?(status)
		end

		def status_keys
			@status_sets.keys
		end

		def status_values
			@status_sets.values
		end

		def status_value(status)
			@status_sets[:key]
		end

		def status_key(value)
			@status_sets.select{ |status, _value| _value == value}.first[0]
		end

		def add_status_group(group_status)
			@group_statuses << group_status
		end
	end

	class GroupStatus
		attr_accessor :group_status_name, :statuses

		def initialize(group_status_name, statuses=nil)
			@group_status_name = group_status_name
			@statuses = statuses || []
		end

		def add_statuse(status)
			@statuses << status
		end
	end
end