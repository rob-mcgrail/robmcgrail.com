class Router
# The Router class, aka R.
#
# Connects requests to controllers, and also provides named routes for
# creating links: link_to(R.thing_url, 'Go to thing')
#
# Routes are added to the router as:
#
# R.add 'path', 'Class#method', 'nickname'
#
# Nicknames become class methods of the router, with a _url suffix, which return paths,
# so to lookup the url of 'home' is R.home_url.
#
# The router connects requests to queries via Router.connect(relative_path)
#
# Router.who_controls(relative_path) returns the Class#method for that url

  @@routes = {}
  # Todo:
  # * Params/rest actions in routes like /thing/1/new
  # * Something that generates a static file of all routes on startup?
  # * Optimise #connect -> do I need to be running split every time?
  # * Find a nicer api than #add. #<< Wont accept multiple comma sep args
  # for some reason...

  class << self
    # Adds route to @@routes hash and generates _url helper.
    def add(path, action, name)
      @@routes[path] = action
      class_eval %Q?
        def self.#{name}_url
          "#{path}"
        end
      ?
    end

    # Connects relative_path to respective controller Class#method.
    # Throws Error#not_found if no routing is possible.
    #
    # This is currently very simplistic and will get complicated the minute
    # we start putting params in routes for resources.
    def connect(path)
      if @@routes[path].nil?
        Error.new.not_found
      else
        controller = @@routes[path].split('#')
        obj = Kernel.const_get(controller[0]).new
        obj.send(controller[1])
      end
    end

    # Returns Class#method for a specific path.
    def who_controls(path)
      @@routes[path]
    end

  end # class << self
end

R = Router

