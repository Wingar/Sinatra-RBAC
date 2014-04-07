require 'bundler/setup'
require './database'
Bundler.require :default # Autobundle every entry in the gem file

Dir["./models/main.*.rb"].each &method(:require)

configure :development do
	use BetterErrors::Middleware
	BetterErrors.application_root = __dir__
end

page_not_logged_in = <<-eos
		<html><head><title>Permission Error</title></head>
		<body>
		To access this page you need to be logged in to a user with the following permissions: #{e.permissions.join(", ")}
		</body>
		</html>
		eos

page_invalid_permission = <<-eos
		<html><head><title>Permission Error</title></head>
		<body>
		You lack sufficient permissions. Missing: #{e.permissions.join(", ")}
		</body>
		</html>
		eos

fourohfour_page = <<-eos
		<html><head><title>Error.</title></head><body>Cannot find page.</body></html>
		eos

get '/' do
	page = ""
	page << "<html><head><title>SinatraRBAC</title></head>
	<body>"
	result = Page.all
	result.each do |p|
		page << "<a href='/page/#{p.title}'>#{p.title}</a><br>"
	end
	page << "</body></html>"
end

get '/page/:article' do
	begin
		page = Page.first(:title => params["article"].downcase)
		Security.direct_has_permissions?(page.permissions)
		<<-eos
		<html>
		<head>
			<title>#{page.title}</title>
		</head>
		<body>
			#{page.contents}
		</body>
		</html>
		eos
	rescue Security::NotLoggedInError => e
		page_not_logged_in
	rescue Security::PermissionsError => e
		page_invalid_permission
	rescue
		fourohfour_page
	end
end

get '/page/blocked' do
	begin
		Security.has_permissions?(["permission_that_doesnt_exist"])
		<<-eos
		<html>
		<head>
			<title>What?</title>
		</head>
		<body>
			<p>You shouldn't be able to get here, what did you do</p>
		</body>
		</html>
		eos
	rescue Security::NotLoggedInError => e
		page_not_logged_in
	rescue Security::PermissionsError => e
		page_invalid_permission
	end
end

get '/login' do
	'<html>
	<head><title>Login</title></head>
	<body>
		<form action="" method="post">
			Username: <input name="user" type="text"><br>
			Password: <input name="password" type="password"><br>
			<input type="submit" value="Submit">
		</form>
	</body>
	</html>'
end

post '/login' do
	if result = User.authenticate(params["user"], params["password"])
		response.set_cookie("user", :value => result.nick, :path => '/')
		response.set_cookie("auth", :value => User.cookie_hash(result.nick, result.pass), :path => '/')
		redirect '/'
	else
		'<html>
		<head><title>Login Failed - Try Again</title></head>
		<body>
			<form action="" method="post">
				Username: <input name="user" type="text"><br>
				Password: <input name="password" type="password"><br>
				<input type="submit" value="Submit">
			</form>
		</body>
		</html>'
	end
end

get '/logout' do
	session.clear
	response.delete_cookie("user")
	response.delete_cookie("auth")
	redirect '/'
end