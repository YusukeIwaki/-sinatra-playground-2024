require 'bundler'
Bundler.require :default, (ENV['RACK_ENV'] || :development).to_sym

loader = Zeitwerk::Loader.new
loader.push_dir('./models')
loader.setup

require 'sinatra/base'

class App < Sinatra::Base
  configure :development do
    set :host_authorization, { permitted_hosts: [] }
  end

  get '/ping' do
    content_type 'application/json'
    { success: true }.to_json
  end

  post '/users' do
    content_type 'application/json'

    user = User.create!

    {
      id: user.id,
      created_at: user.created_at.to_i,
    }.to_json
  end

  patch '/users/:id' do
    content_type 'application/json'

    user = User.find(params[:id])

    request_json = JSON.parse(request.body.read)
    display_name = request_json['display_name']
    email = request_json['email']

    profile = Profile.find_or_initialize_by(user: user)
    profile.update!(display_name: display_name, email: email)

    {
      id: user.id,
      profile: {
        display_name: profile.display_name,
        email: profile.email,
      }
    }.to_json
  end
end
