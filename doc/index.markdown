#Desert -- It doesn't get any DRYer than this
Desert is a Rails plugin framework that makes it easy to share models, views, controllers, helpers, routes, and migrations across your applications.
With Desert, reusability doesn't come at the cost of extensibility: it's trivial to extend the functionality of a plugin--both in your application _and_ in other plugins.


"I tried generators, but all I got was a bunch of code duplication. With Desert, I've been able to re-use all of my social networking functionality without a single duplicated character! Thanks Desert!"

-- Nick Kallen, Developer

"DHH says components are a pipe dream. Desert makes this dream a reality."

-- Brian Takita, Software Engineer

"I installed Appable Plugins, but then my application exploded. Great theory, but oh what a headache. Desert looks good on the drawing board and even better in production."

-- Nathan Sobo, Programmer

##Anatomy of a Desert Plugin
Desert enables your plugins to contain the standard Rails directory structure.
When you want to extract part of your application into a plugin, just drag files into the `vendor/plugins` directory.

    rails_root/
      app/
        controllers/
          blogs_controller.rb
          users_controller.rb
        helpers/
          blogs_helper.rb
          users_helper.rb
        models/
          blog.rb
          user.rb
        views/
          users/
            edit.html.erb
            show.html.erb
          lib/
            current_user.rb
      db/
        migrate/
          001_
      vendor/
        plugins/
        user/
          init.rb
        app/
          controllers/
            users_controller.rb
          helpers/
            users_helper.rb
          models/
            user.rb
          views/
            users/
              show.html.erb
              edit.html.erb
            lib/
              current_user.rb

##Installation
    gem install desert

##Loading Desert
Require desert above the Rails Initializer at the __TOP__ of `config/environment.rb`:

`config/environment.rb`
    require "desert"
    Rails::Initializer.run do |config|
      ...
    end
  

Note: __AT THE TOP__



##Managing Plugin Dependencies
By default, Rails loads plugins in alphabetical order, making it tedious to manage dependencies.
Desert will automatically load plugins in the proper order when you declare their dependencies like this:

`vendor/plugins/blogs/init.rb`

    require_plugin 'user'
    require_plugin 'will_paginate'

Here `user` and `will_paginate` will always be loaded before `blogs`. Note that any plugin can be declared as a dependency.

##Designed For Extensibility
One of Ruby's key features is the ability to reopen classes and customize their behavior. Desert gives your plugins the same power.

In the user plugin:
`vendor/plugins/user/app/models/user.rb`

    class User < ActiveRecord::Base
      def welcome_message
        "Welcome #{full_name}"
      end
    end

In the blogs plugin:
`vendor/plugins/blogs/app/models/user.rb`

    class User < ActiveRecord::Base
      has_one :blog
    
      def welcome_message
        "Welcome to #{blog_title}, #{full_name}"
      end
      
      def blog_title
        "Your Blog"
      end
    end

In the application:
`app/models/user.rb`

    class User < ActiveRecord::Base
      def blog_title
        "Acme Corp's blog"
      end
    end


Here the `blogs` plugin overrides a method in the `User` class that's defined in the `user` plugin.
The `blogs` plugin also adds a `has_one :blog` declaration to `User`.
The application overrides the `blog_title` template method, defined in the `blogs` plugin.

Note that controllers and helpers can be extended in the same way.

##Sharing Routes
When you share controllers, you'll want to share their routes too:

In the `user` plugin:
`vendor/plugins/user/config/routes.rb`

    resource :users

In the `blogs` plugin: 
`vendor/plugins/blogs/config/routes.rb`

    resource :blogs

In the application:
`config/routes.rb`

    ActionController::Routing::Routes.draw do |map|
      map.routes_from_plugin :blogs
      map.routes_from_plugin :user
    end

Here the application adds the `users` resource from the `user` plugin and the `blogs` resource from the `blogs` plugin.
Notice that there is no need to call methods on map in the plugin route files, because they are instance eval'd in the map object.

##Sharing Migrations
Sharing models means sharing schema fragments, and that means sharing migrations:

In the `user` plugin:

    vendor/plugins/user/db/migrate/
      001_create_user_table.rb

In the `blogs` plugin:

    vendor/plugins/blogs/db/migrate/
      001_create_user_table.rb
      002_add_became_a_blogger_at_to_user.rb

Here the `blogs` plugin needs to add a column to the `users` table. No problem!
It just includes a migration in its `db/migrate` directory, just like a regular Rails application.
When the application developer installs the plugin, he migrates the plugin in his own migration:
      
`application_root/db/migrate/009_install_user_and_blogs_plugins.rb`
  
    class InstallUserAndBlogsPlugins < ActiveRecord::Migration
      def self.up
        migrate_plugin 'user', 1
        migrate_plugin 'blogs', 2
      end
      
      def self.down
        migrate_plugin 'user', 0
        migrate_plugin 'blogs', 0
      end
    end
    
Here the application migrates the `user` plugin to version 1 and the `blogs` plugin to version 2.
If a subsequent version of the plugin introduces new migrations, the application developer has full control over when to apply them to his schema.

##Share Views
To share views, just create templates and partials in the plugin's `app/views` directory, just as you would with a Rails application.

`application_root/app/views/blogs/index.html.erb`

    <%= @blog.posts.each do |post| %>
      ...
    <% end %>

    class InstallUserAndBlogsPlugins < ActiveRecord::Migration
    def self.up
      migrate_plugin 'user', 1
      migrate_plugin 'blogs', 2
    end