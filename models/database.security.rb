class PermissionRole
	include DataMapper::Resource

	property :id, Serial

	belongs_to :permission
	belongs_to :role
end

class Permission
	include DataMapper::Resource

	property :id, Serial
	property :name, String, :required => true, :unique_index => :permission_title
end

class Role
	include DataMapper::Resource

	property :id, Serial
	property :name, String, :required => true, :unique_index => :role_title

	has n, :permission_roles
	has n, :permissions, :through => :permission_roles
end

class RoleUser
	include DataMapper::Resource

	property :id, Serial

	belongs_to :role
	belongs_to :user
end

class PermissionPage
	include DataMapper::Resource

	property :id, Serial

	belongs_to :permission
	belongs_to :page
end
