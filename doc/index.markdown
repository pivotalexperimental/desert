#Desert -- It doesn't get any DRYer than this
Desert takes Rails plugins to the extreme. With incredible ease, you can share models, views, controllers, helpers, routes, and migrations across all of your applications -- all without using generators. You can also layer plugins on top of each another and manage their dependencies declaratively.

##Anatomy of a Desert Plugin
Desert plugins contain the standard Rails directory structure:

[EXAMPLE ... extracting a plugin]

When you want to turn part of your application into a plugin, just drag files into the `vendor/plugins` directory. Now you can share this application slice with all of your other applications.

##Managing Plugin Dependencies
By default, Rails loads plugins in alphabetical order, making it tedious to manage dependencies. Desert will automatically load plugins in the proper order when you declare their dependencies like this:

[IMAGE HERE ... picture of the init.rb --- will_paginate and another desert plugin in the file system]

vendor/plugins/user/init.rb

vendor/plugins/blogs/init.rb
require_plugin 'user'


##Designed For Extensibility
One of Ruby's key features is the ability to reopen classes and customize their behavior. Desert plugins give you this same power.

[EXAMPLE ... reopening the User class in two plugins plus the app]

    vendor/plugins/user/app/model/user.rb
    class User < ActiveRecord::Base
      def welcome_message
        "Welcome #{full_name}"
      end
    end

    vendor/plugins/blog/app/model/user.rb
    class User < ActiveRecord::Base
      def welcome_message
        "Welcome to #{blog_title}, #{full_name}"
      end
      
      def blog_title
        "Your Blog"
      end
    end

    app/model/user.rb
    class User < ActiveRecord::Base
      def blog_title
        "Acme Corp's blog"
      end
    end
    [caption describing what happens in the above image]

##Sharing Routes
When you share controllers, you'll want to share their routes too:

    vendor/plugins/user/config/routes.rb
    resource :users
    
    vendor/plugins/blog/config/routes.rb
    resource :blogs

    config/routes.rb
    ActionController::Routing::Routes.draw do |map|
      map.routes_from_plugin :blog
      map.routes_from_plugin :user
    end

In the example the application adds the users resource from the user plugin and the blogs resource from the blog plugin.
Notice that there is no need to call methods on map in the plugin route files, because they are instance eval'd in the map object.

##Sharing Migrations
Sharing models means sharing schemas, and that means sharing migrations:






EXAMPLE:Extracting a plugin
rails_root/
  /app
    controllers/
      foo_controller.rb
      bar_controller.rb
      users_controller.rb
    helpers/
      users_helper.rb
    models/
      foo.rb
      bar.rb
      user.rb
    views/
      users/
        show.html.erb
        edit.html.erb
  lib/
    current_user.rb

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





















#Icebox



##How does it work?

Normally, Rails automatically loads the first file it finds matching the name of a missing constant. With Desert, all matching files from plugins and the application itself will be loaded. This allows plugins to build upon resources introduced by other plugins. If the application has a matching file, it is loaded last.

Your application can reopen classes introduced by plugins, allowing you to customize models and controllers








It's elegant in theory and rock solid in practice.

It's rock solid. Proven on real-world production Rails applications; desert can manage the dependences of dozens of plugins without a single defect--without breaking a sweat.

DRY (Desert)

I've heard of things like this before? What's so special about desert?

Unlike other plugin technologies, Desert has been proven on dozens real-world applications.


Fulfilling the promise of components.




plugins have never been so powerful and reusa.

By default, Rails loads plugins in alphabetical order. If a plugin depends on another plugin being loaded before it, you must specify a custom load order in your environment file. But this places the burden of the plugin's dependencies on the application developer.

##Don't Generate, Integrate!
Some Rails plugins bundle generators. This allows them to add new models, controllers, and views to the application. This makes their code easy to understand and extend: you just change the generated code. But . It's difficult to incorporate changes as the plugin evolves and hard to share code between multiple applications.

Other plugins use mixins to enhance existing application resources. This enhances reusability, but makes it harder for plugins to introduce new resources. If 


Desert offers the best of both worlds. Like normal Rails applications, Desert plugins define models, views, controllers, helpers, and other library files in standard directories. To Rails, it appears as if the plugin's resources are part of the application.


"I tried generators, but all I got was a bunch of code duplication. With Desert, I've been able to re-use all of my social networking functionality without a single duplicated character! Thanks Desert!"

-- Nick Kallen, Developer

"DHH says components are a pipe dream. Desert makes this dream a reality."

-- Brian Takita, Software Engineer

"I installed Appable Plugins, but then my application exploded. Great theory, but oh what a headache. Desert looks good on the drawing board and even better in production."

-- Nathan Sobo, Programmer