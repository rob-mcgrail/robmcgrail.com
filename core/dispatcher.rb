class Dispatcher
  # Interacts with rack, receiving the standard env object, passing off the path
  # to the router, receiving a response (from Renderer#render, via Controller#method, Router.connect)
  class << self

    def <<(env)
      begin
        @response = Router.connect(env.path)
      rescue
        if DEVELOPMENT_MODE
          raise
        else
          @response = Error.new.bug
        end
      end


      [
        @response[:code] || '200',
        @response[:type] || {"Content-Type" => "text/html"},
        @response[:body] || '<h1>Very serious problem</h1>',
      ]
    end

  end # class << self
end

