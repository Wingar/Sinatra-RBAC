require 'data_mapper'
require 'dm-migrations'
require './config'

DataMapper.setup(:default, "#{@dbtype}://#{@user}:#{@pass}@#{@host}/#{@database}") 

Dir["./models/database.*.rb"].each &method(:require)

class Page
	include DataMapper::Resource

	property :id, Serial
	property :title, String, :required => true, :unique_index => :page_title
	property :contents, Text, :required => true

	has n, :permission_pages
	has n, :permissions, :through => :permission_pages
end

class User
	include DataMapper::Resource

	property :id, Serial
	property :nick, String, :length => 90, :required => true, :unique_index => :nickname
	property :pass, String, :length => 45, :required => true

	has n, :role_users
	has n, :roles, :through => :roleuser

	def self.make_hash(password, username, difficulty = 1000)
		finalHash = password + username
		for i in 0..difficulty
			finalHash = Digest::SHA1.hexdigest(Digest::SHA1.hexdigest(i.to_s) + password + username + finalHash + i.to_s)
		end
		"lol" + finalHash
	end

	def self.authenticate(username, pass)
		user = User.first(:nick => username)
		return nil if user.nil?
		return user if User.make_hash(pass, username) == user.pass
		nil
	end

	def self.cookie_hash(user, passhash)
		Digest::SHA1.hexdigest(passhash + user)
	end

	def self.new_user(nick, password)
		user = User.new
		user.nick = nick
		user.pass = User.make_hash(password, nick)
		user.save
	end
end

DataMapper.finalize