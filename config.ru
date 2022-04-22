require 'rack'
require_relative 'scumbag'

class Scumbag
  def call(env)
    params = Rack::Utils.parse_nested_query(env['QUERY_STRING'])
    scumbag = params['scumbag'] || 'your mom'
    scumbag_gender = params['gender'] || 'other'
    num_insults = params['num'].to_i.clamp(1..100) || 1
    status = 200
    headers = { 'Content-Type' => 'text/ascii' }
    body = (1..num_insults).map { get_story(scumbag, scumbag_gender) }.to_a.join("\n")

    [status, headers, [body]]
  end
end

run Scumbag.new
