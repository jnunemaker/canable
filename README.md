# Canable

Simple Ruby authorization system.

## Install

```
gem install canable
```

## Cans

Whatever class you want all permissions to run through should include Canable::Cans.

```ruby
class User
  include MongoMapper::Document
  include Canable::Cans
end
```

This means that an instance of a user automatically gets can methods for the default REST actions: `can_view?(resource)`, `can_create?(resource)`, `can_update?(resource)`, `can_destroy?(resource)`.

## Ables

Each of the can methods simply calls the related "able" method (viewable, creatable, updatable, destroyable) for the action (view, create, update, delete). Canable comes with defaults for this methods that you can then override as makes sense for your permissions.

```ruby
class Article
  include MongoMapper::Document
  include Canable::Ables
end
```

Including Canable::Ables adds the able methods to the class including it. In this instance, article now has `viewable_by?(user)`, `creatable_by?(user)`, `updatable_by?(user)` and `destroyable_by?(user)`.

Lets say an article can be viewed and created by anyone, but only updated or destroyed by the user that created the article. To do that, you could leave `viewable_by?` and `creatable_by?` alone as they default to true and just override the other methods.

```ruby
class Article
  include MongoMapper::Document
  include Canable::Ables
  userstamps! # adds creator and updater

  def updatable_by?(user)
    creator == user
  end

  def destroyable_by?(user)
    updatable_by?(user)
  end
end
```

Let's look at some sample code now:

```ruby
john = User.create(:name => 'John')
steve = User.create(:name => 'Steve')

ruby = Article.new(:title => 'Ruby')
john.can_create?(ruby) # true
steve.can_create?(ruby) # true

ruby.creator = john
ruby.save

john.can_view?(ruby) # true
steve.can_view?(ruby) # true

john.can_update?(ruby) # true
steve.can_update?(ruby) # false

john.can_destroy?(ruby) # true
steve.can_destroy?(ruby) # false
```

Now we can implement our permissions for each resource and then always check whether a user can or cannot do something. This makes it all really easy to test. In one common pattern, a single permission flag controls whether or not users can perform multiple administrator-specific operations. Canable can honor that flag with:

```ruby
def writable_by?(user)
  user.can_do_anything?
end
alias_method :creatable_by?, :writable_by?
alias_method :updatable_by?, :writable_by?
alias_method :destroyable_by?, :writable_by?
```

Next, how would you use this in the controller. 

## Enforcers

```ruby
class ApplicationController
  include Canable::Enforcers
end
```

Including `Canable::Enforcers` adds an enforce permission method for each of the actions defined (by default view/create/update/destroy). It is the same thing as doing this for each Canable action:

```ruby
class ApplicationController
  include Canable::Enforcers

  delegate :can_view?, :to => :current_user
  helper_method :can_view? # so you can use it in your views
  hide_action :can_view?

  private
    def enforce_view_permission(resource)
      raise Canable::Transgression unless can_view?(resource)
    end
end
```

Which means you can use it like this:

```ruby
class ArticlesController < ApplicationController
  def show
    @article = Article.find!(params[:id])
    enforce_view_permission(@article)
  end
end
```

If the user `can_view?` the article, all is well. If not, a `Canable::Transgression` is raised which you can decide how to handle (show 404, slap them on the wrist, etc.). For example:

```ruby
class ApplicationController < ActionController::Base
  rescue_from Canable::Transgression, :with => :render_403

  protected
  def render_403(e)
    # notify normal exception handler(s) here
    render :status => 403
  end
```

## Adding Your Own Actions

You can add your own actions like this:

```ruby
Canable.add(:publish, :publishable)
```

The first parameter is the can method (ie: `can_publish?`) and the second is the able method (ie: `publishable_by?`).

Ables can also be added as class methods. For example, to restrict access to an index action:

```ruby
Canable.add(:index, :indexable)
```

Then enforce by passing the class instead of the instance:

```ruby
class ArticlesController < ApplicationController
  def index
    @articles = Article.all
    enforce_index_permission(Article)
  end
end
```

Then in the article model, add the able check as a class method:

```ruby
class Article
  # ...
  def self.indexable_by?(user)
    !user.nil?
  end
end
```

## Review

So, lets review: cans go on user model, ables go on everything, you override ables in each model where you want to enforce permissions, and enforcers go after each time you find or initialize an object in a controller. Bing, bang, boom.

## Contributing

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2010 John Nunemaker. See LICENSE for details.
