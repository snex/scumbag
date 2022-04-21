require 'rack'
require_relative 'scumbag'

class Scumbag
  def call(env)
    params = Rack::Utils.parse_nested_query(env['QUERY_STRING'])
    scumbag = params['scumbag'] || 'your mom'
    scumbag_gender = params['gender'] || 'other'
    status = 200
    headers = { 'Content-Type' => 'text/ascii' }
    body = [get_story(scumbag, scumbag_gender)]

    [status, headers, body]
  end
end

run Scumbag.new
