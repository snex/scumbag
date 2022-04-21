require 'rack'
require_relative 'scumbag'

class Scumbag
  def call(env)
    scumbag = Rack::Utils.parse_nested_query(env['QUERY_STRING'])['scumbag'] || 'your mom'
    status = 200
    headers = { 'Content-Type' => 'text/ascii' }
    body = [get_story(scumbag)]

    [status, headers, body]
  end
end

run Scumbag.new
