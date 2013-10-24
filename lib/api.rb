require './lib/idea_box'
require 'json'

class IdeaBoxAPI < Sinatra::Base

  # GO FIND A NICE QUOTE - and interpolate the EUID
  # Digest::SHA1.hexdigest(string)
  # save on user
  #
  # FARADAY
  #
  # Bundle gem (scaffold)
  # VCR ---

  set :root, 'lib/api'
  set :method_override, true

  helpers do

    def authorize!(access_key)
      user = User.find_by_access_key(access_key)
      unless user
        halt 401, {
          error: "You must be logged in to access this feature.
                  Please double-check your API key."
        }.to_json
      end
      user
    end

    def current_user
      false
    end
  end

  get '/' do
    authorize!(params[:access_key])
  end

  get '/ideas' do
    user = authorize!(params[:access_key])
    data = user.ideas.each_with_object({:ideas => []}) do |idea, hash|
      hash[:ideas] << idea.to_h
    end.to_json
  end

  post '/ideas/new' do
    params = JSON.parse(request.body.read.to_s)
    user = authorize!(params["access_key"])
    idea = Idea.new(params["idea"].merge({"user_id" => user.id}))
    idea.save
    {"success" => "Thanks, #{user.name}, for creating '#{idea.title}' !!"}.to_json
  end

  put '/ideas/:id' do |id|
    params = JSON.parse(request.body.read.to_s)
    authorize!(params["access_key"])
    idea = Idea.find(id.to_i)
    idea.update_attributes(params["idea"])
  end

  delete '/ideas/:id' do |id|
    params = JSON.parse(request.body.read.to_s)
    authorize!(params["access_key"])
    Idea.delete(id.to_i)
  end
end
