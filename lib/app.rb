require './lib/app/auth'
require './lib/app/ideas'
require './lib/app/sms'
require './lib/app/users'
require './lib/idea_box'

require 'better_errors'
require 'sass'

require './lib/app/helpers/asset_handler'

class IdeaBoxApp < Sinatra::Base

  set :root, 'lib/app'
  set :method_override, true

  enable :sessions

  configure :development do
    use BetterErrors::Middleware
    BetterErrors.application_root = 'lib/app'
    register Sinatra::Reloader
  end

  helpers do
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
    def authorize!
      if current_user.nil?
        redirect '/'
      end
    end
  end

  not_found do
    haml :error
  end

  get '/activity' do
    authorize!
    ideas = Idea.all.reverse
    users = User.all
    haml :activity, locals: { ideas: ideas, users: users, idea: Idea.new }
  end

end
