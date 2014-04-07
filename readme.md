Sinatra RBAC
============

What is this?
-------------
This is small project is a personal reference implementation of an RBAC authentication system. It's built on top of Sinatra and Datamapper (It probably wouldn't be hard to move over to AR, Sequel or Ruby Object Mapper). My password system is less than ideal, I know, but it's unimportant and I urge you to just use bcrypt in your own projects. I also know my use of cookies is pretty terrible, I don't use them like this anymore, just focus on the security aspects of this. This is an old project and I was still adjusting and learning Rack/Sinatra/Rails.

Why am I publishing this?
-------------------------
Dunno. Why not? Someone might get some help out of it. 

How do I use this?
------------------
Pretty simple, set up a database of your choice and set up the `config.rb` from `config.example.rb`, `bundle install` and then `rake db:migrate` and `rake db:testusers`. Then fire it up with either `ruby app.rb` or `rackup`. 

How does this work?
-------------------
Under models, there's two files, `database.security.rb` and `main.security.rb`. The database file is purely datamapper tables and is fairly unimportant. Under the main file there's some error classes and some functions. 

The two functions are `Security.has_permissions?(required_permission_array, username)` and `Security.direct_has_permissions?(required_permission_list, username)`

The implementation of both is a bit janky, I'll get into that in a second. 
The first is used to check if the user can access the page. If the user can't, it will throw an appropriate error. If they can, it will do nothing. This is where the janky-ness comes from. You put it at the start of a page under a begin section with rescues for the errors and put everything on the page after the function call. You can see an example in app.rb from line `66` to `84`.
The next is a "direct" call, it will allow you to take a datamapper list instead of an array and use it in the same fashion as the last. You can see an example of this from line `43` to `64` in `app.rb`

I also urge you to never use this code directly. Build it yourself, this code has a lot of problems and is just not that great. I've learned a lot since then but I still look back at this to remind me of how RBAC works in the first place and hopefully someone else can learn from this, too.