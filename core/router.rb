class Route
  attr_accessor :space, :params, :controller, :order, :name
  def initialize
      @space = nil
      @params = {}
      @controller = nil
      @order = []
  end


  def to_s
    puts @space
    puts @params.inspect
    puts @controller
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
# Router.who_controls(relative_path) returns the Class#method for that url

  @@routes = {}
  # Todo:
  # * Params/rest actions in routes like /thing/1/new
  # * Something that generates a static file of all routes on startup?
  # * Optimise #connect -> do I need to be running split every time?
  # * Find a nicer api than #add. #<< Wont accept multiple comma sep args
  # for some reason...

  # Adds route to @@routes hash and generates _url helper.
  def self.add(path, action, name)
    # Get rid of first and last slash if present
    path.slice!(0) if path[0,1] == '/'
    path.slice!(-1) if path[-1,1] == '/'
    #path = {:space => 'blog', :category => '1', :slug => 'something'}
    r = routerize(path)
    r.controller = action

    @@routes[r.space] = r

    class_eval %Q?
      def self.#{name}_url
        "#{r.space}"
      end
    ?
  end


  def self.routerize(path)
    r = Route.new
    r.space = '/' + /^[a-zA-Z_\-\/0-9]+/.match(path).to_s.chomp('/')

    a = path.scan(/:([a-z_\-]+)/)
    a.each do |p|
      r.params[p[0].to_sym]=":#{p}"
      r.order << p[0].to_sym
    end
    r
  end


  def self.connect(path)
    if path.length > 1
      path.slice!(-1) if path[-1,1] == '/'
    end

    if @@routes[path] != nil
      controller = @@routes[path].controller.split('#')
      obj = Kernel.const_get(controller[0]).new
      obj.send(controller[1])
    else

      fullpath = path.dup
      i = 0

      while @@routes[path] == nil
        shrink path
        i+=1
      end

      r = @@routes[path]

      if i != r.order.length
        return Error.new.not_found
      end

      params = parse_to_params(fullpath, r.order)

      controller = r.controller.split('#')
      obj = Kernel.const_get(controller[0]).new
      obj.send(controller[1], params)
    end
  end

  private

  def self.shrink(p, i=1)
    i.times do
      p.sub!(/\/[^\/]*$/, '')
    end
    p
  end


  def self.parse_to_params(path, params)
    p = {}
    params.each do |param|
      p[param] = /[^\/]*$/.match(path).to_s
      path = shrink(path)
    end
    p
  end

end

R = Router

