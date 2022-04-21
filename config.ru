require 'rack'
require_relative 'scumbag'

class Scumbag
  def call(env)
    status = 200
    headers = { 'Content-Type' => 'text/ascii' }
    body = [get_story('Matt Vaughan')]

    [status, headers, body]
  end
end

run Scumbag.new
