require './lib/idea_box'
require './lib/app/helpers/asset_handler'
require 'better_errors'
require 'sass'

class IdeaBoxApp < Sinatra::Base

  set :root, 'lib/app'
  set :method_override, true

  enable :sessions

  register Sinatra::AssetPack

  assets {
    serve '/js',     from: 'assets/js'        # Default
    serve '/css',    from: 'assets/css'       # Default
    serve '/images', from: 'assets/images'    # Default

    # The second parameter defines where the compressed version will be served.
    # (Note: that parameter is optional, AssetPack will figure it out.)
    js :app, '/js/app.js', [
      '/js/vendor/**/*.js',
      '/js/lib/**/*.js'
    ]

    css :application, '/css/application.css', [
      '/css/app.css'
    ]

    js_compression  :jsmin    # :jsmin | :yui | :closure | :uglify
    css_compression :sass     # :simple | :sass | :yui | :sqwish
  }

  configure :development do
    use BetterErrors::Middleware
    BetterErrors.application_root = 'lib/app'
    register Sinatra::Reloader
  end

  helpers do
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
  end

  # You'll need to customize the following line. Replace the CONSUMER_KEY
  #   and CONSUMER_SECRET with the values you got from Twitter
  #   (https://dev.twitter.com/apps/new).
  use OmniAuth::Strategies::Twitter, 'Hxa2BN3YRedsQRXCrYHFA', 'EG9wDKRsAOyXcTSlglDC8JcCq9vVINl4ScDKaG9pQ'

  not_found do
    haml :error
  end

  get '/' do
    haml :index, locals: { ideas: Idea.all.sort, idea: Idea.new }
  end

  post '/' do
    params[:idea].merge!({"user_id" => current_user.id})
    Idea.create(params[:idea])
    redirect "/"
  end

  get '/:id/edit' do |id|
    idea = Idea.find(id.to_i)
    haml :edit, locals: { idea: idea }
  end

  put '/:id' do |id|
    #if request.headers["Content-Type"] == "application/json"
    #  # make json
    #else
    Idea.update(id.to_i, params[:idea])
    redirect '/'
  end

  delete '/:id' do |id|
    Idea.delete(id.to_i)
    redirect '/'
  end

  post '/:id/like' do |id|
    idea = Idea.find(id.to_i)
    idea.like!
    redirect '/'
  end

  get '/tags' do
    ideas = Idea.all
  end

  get '/users' do
    users = User.all
    haml :users, locals: { users: users }
  end

  get '/users/:nickname' do |nickname|
    user = User.find_by_nickname(nickname)
    haml :user, locals: { user: user }
  end

  get '/logout' do
    session[:user_id] = nil
    redirect '/'
  end

  ["/login/?", "/signup/?"].each do |path|
    get path do
      redirect '/auth/twitter'
    end
  end

  get '/auth/twitter/callback' do
    auth = request.env["omniauth.auth"]
    user = User.first_or_create(
      {:uid => auth["uid"]},
      {
        :uid        => auth["uid"],
        :nickname   => auth["info"]["nickname"],
        :name       => auth["info"]["name"],
        :image      => auth["info"]["image"]
      }
    )

    session[:user_id] = user.id
    redirect '/'
  end


end
