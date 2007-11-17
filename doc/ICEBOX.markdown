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