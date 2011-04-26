class Dispatcher
  # Interacts with rack, receiving the standard env object, passing off the path
  # to the router, receiving a response (from Renderer#render, via Controller#method, Router.connect)
  class << self

    def <<(env)
      @response = Router.connect(env.path)

      if @response.class != Hash
        @response = {:code => nil, :type => nil, :body => nil}
      end

      [
        @response[:code] || '501',
        @response[:type] || {"Content-Type" => "text/html"},
        @response[:body] || '<h1>Very serious problem</h1>',
      ]
    end

  end # class << self
end

