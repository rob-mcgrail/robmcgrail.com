# A fake rack request
require 'rack'
class Env < Rack::Request
  attr_accessor :path

  def initialize(path)
    @path = path
  end

  def POST()
    {}
  end
end

