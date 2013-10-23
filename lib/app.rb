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

  register Sinatra::AssetPack

  assets {
    serve '/js',     from: 'assets/js'        # Default
    serve '/css',    from: 'assets/css'       # Default
    serve '/images', from: 'assets/images'    # Default

    # The second parameter defines where the compressed version will be served.
    # (Note: that parameter is optional, AssetPack will figure it out.)
    js :app, '/js/app.js', [
      '/js/scripts.js'
      #'/js/vendor/**/*.js',
      #'/js/lib/**/*.js'
    ]

    css :application, '/css/application.css', [
      '/css/app.css'
    ]

    js_compression  :jsmin    # :jsmin | :yui | :closure | :uglify
    css_compression :sass     # :simple | :sass | :yui | :sqwish
  }

  configure do
    Pusher.app_id = '57501'
    Pusher.key    = '3568c8046d9171a5f8ee'
    Pusher.secret = '780e1174f5e7438514f6'
  end

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

  not_found do
    haml :error
  end

end
