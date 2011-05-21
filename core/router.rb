class Route
# The Route object, used in the Router's @@router hash.
# Simply a container for the various route facts.
  attr_accessor :space, :params, :action, :order
  # @space:
  #
  # The 'namespace' for the route. For simple routes like 'somepage' or 'about/this-site'
  # this is all that's required to make a conncetion - the path is the @space.
  # For others, like 'blog/march/12/awesome', the namespace is the static section of the path,
  # 'blog'. In any situation @space can contain slashes. Params are marked out via : in the route
  # definition, ala rails.
  #
  # @params:
  #
  # A hash of the params. {:month => 12, :day => 12, :title => awesome}
  #
  # @action:
  #
  # Action is the route's Controller and action, in the form of a string like Main#homepage.
  # This can be a class/instance method pair from anywhere, but normally it will be defined in the
  # /controllers folder.
  #
  # @order:
  #
  # Order is an array of the params, as symbols. [:month, :day, :title]. This is used as a simple way
  # of remembering the order and ammount of params. (r.order.each... r.order.length)

  def initialize
      @space = nil
      @params = {}
      @action = nil
      @order = []
  end


  def to_s
    puts @space
    puts @params.inspect
    puts @action
    puts @order
  end

end

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
# Router understands params in paths, and you can define routes rails style like:
#
# R.add 'blog/:month/:day/:title', 'Blog#show', 'blog_post'
#
# Which will interpret 'blog/july/12/how-is-everyone', and pass a params hash to the
# Blog#show method.


  @@routes = {'' => Route.new}
#? like this ?  @@post_routes = {'' => Route.new}

  # Adds route to @@routes hash and generates _url helper.
  def self.add(path, action, name)
    # make name an option, along with type (get, post etc)
    # then make get and post method wrapping add
    # then add the types to the route object, and they can be queried in a
    # dispath method in connect


    # Get rid of first and last slash if present.
    path.slice!(0)  if path[0,1] == '/'
    path.slice!(-1) if path[-1,1] == '/'
    # convert to a Route object.
    r = routerize(path, action)
    # Add to @@routes.
    # Can now be retrieved by r.space, the string of the static component of the path.
    @@routes[r.space] = r

    #TIDY ME UP...:

    class_eval %Q?
      def self.#{name}_url(p={})

        url = "#{r.space}"
        if #{r.order.length} > 0
          url << '/'
          url << p["#{r.order[0]}".to_sym].to_s
        end
        if #{r.order.length} > 1
          url << '/'
          url << p["#{r.order[1]}".to_sym].to_s
        end
        if #{r.order.length} > 2
          url << '/'
          url << p["#{r.order[2]}".to_sym].to_s
        end
        if #{r.order.length} > 3
          url << '/'
          url << p["#{r.order[3]}".to_sym].to_s
        end
        if #{r.order.length} > 4
          url << '/'
          url << p["#{r.order[4]}".to_sym].to_s
        end
        if #{r.order.length} > 5
          url << '/'
          url << p["#{r.order[5]}".to_sym].to_s
        end
        url
      end
    ?
  end


  def self.routerize(path, action)
    r = Route.new
    # Grab the static section of the route - anything not prefixed by :
    r.space = '/' + /^[a-zA-Z+&%\*\?#_\-\/0-9]+/.match(path).to_s.chomp('/')
    # pass the action in to the Route.
    r.action = action
    # Create an array of anything in the path prefixed by :
    a = path.scan(/:([a-z+&%\*\?#_\-]+)/)
    # Place each :thing in the Route#params hash and the Route#order array
    a.each do |p|
      r.params[p[0].to_sym]=":#{p}"
      r.order << p[0].to_sym
    end
    r
  end

  # The main Router method, that connects path requests from clients to method calls.
  def self.connect(env)
    path = env.path
    # Unless it's the root path ('/'), remove the trailing slash.
    if path.length > 1
      path.slice!(-1) if path[-1,1] == '/'
    end
    # Prefix a slash, if there isn't one
    path = path.insert(0, '/') if path[0,1] != '/'

    # A quick match for simple routes.
    if @@routes[path] != nil
      # Check there aren't meant to be params, to avoid matching
      # stubs of dynamic routes.
      if @@routes[path].order.length == 0
        # Parse the action string ('Class#method'), retrieve the class constant,
        # and send it the method call.



        # to_controller @@routes[path]

        # def to_controller(route)
          # if post? and route post == nil, error
          # otherwise deliver
          # if get? and route
        # end


        action = @@routes[path].action.split('#')
        obj = Kernel.const_get(action[0]).new
        obj.send(action[1])
      else
        return 'error - abstract me out in to a class'
      end
    else
      # Backup the path, we're going to be stripping it down to match against
      # the static part, which is the key for the @@routes hash.
      fullpath = path.dup

      i = 0
      # Strip down the route, by each slash (a/b/c/d => a/b/c => a/b)
      # until a match is made. The @@routes hash contains a '' key, so that
      # completely stripped paths will match, and then fail later returning a 404.
      while @@routes[path] == nil
        shrink path
        i+=1
      end

      # Retrieve the route by the suitably stripped down path.
      route = @@routes[path]
      # Check that the Route expects as many params as we performed strips.
      # This is partly a santiy check, makes sure extra params fails, and fails
      # when there is no match - which matches '' returning an empty Route object.
      if i != route.order.length
        return 'error - abstract me out in to a class' #Error.new.not_found
      end
      # Use the Route#order array to parse the backed up path.
      params = parse_to_params(fullpath, route.order)
      # Parse the action string ('Class#method'), retrieve the class constant,
      # and send it the method call, and the params hash.
      action = route.action.split('#')
      p = OpenStruct.new(params)
      b = OpenStruct.new(env.POST)
      obj = Kernel.const_get(action[0]).new(p, b)
      obj.send(action[1])
    end
  end

  private

  def self.shrink(p, i=1)
    # Strips down path strings like: a/b/c/d => a/b/c => a/b
    i.times do
      p.sub!(/\/[^\/]*$/, '')
    end
    p
  end


  def self.parse_to_params(path, order)
    # Iterates through the path, grabbing the last slashed section,
    # placing it in the params hash with the appropriate key taken from
    # Route.order, and then stripping the url down a step.
    # Repeated until the required params are harvested.
    #
    # Implications are that paths can't look like: static/dynamic/static/dynamic
    #
    # We reverse the order array due to the order returned by #match / shrink combo
    p = {}
    order.reverse.each do |param|
      p[param] = /[^\/]*$/.match(path).to_s
      path = shrink(path)
    end
    p
  end

end

R = Router

