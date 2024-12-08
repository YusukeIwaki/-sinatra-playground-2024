require 'sinatra'
require 'json'

get '/ping' do
  content_type 'application/json'
  { success: true }.to_json
end
