class Security

	class PermissionsError < StandardError
		attr_reader :permissions

		def initialize(permissions)
			@permissions = permissions
		end
	end

	class NotLoggedInError < PermissionsError; end

	def self.has_permissions?(required_permissions, username = nil) # Compare permissions with standard arrays.
		if username.nil? and required_permissions.size > 0
			raise NotLoggedInError.new(required_permissions)
		else
			permission_check = (required_permissions - User.first(username).roles.permissions.map {|permission| permission.name })
			if permission_check.size > 0
				raise PermissionsError.new(permission_check)
			end
		end
	end

	def self.direct_has_permissions?(required_permissions, username = nil) # Compare with a direct DataMapper permission list
		Security.has_permissions?(required_permissions.map {|permission| permission.name})
	end
end