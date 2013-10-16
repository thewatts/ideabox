class AssetHandler < Sinatra::Base
  #configure do
  #  set :views, File.dirname(__FILE__) + '/assets'
  #  set :jsdir, 'js'
  #  set :cssdir, 'css'
  #  enable :coffeescript
  #  set :cssengine, 'scss'
  #  set :root, './lib/app'
  #end

  get '/javascripts/*.js' do
    pass unless settings.coffeescript?
    last_modified File.mtime(settings.root+'/assets/'+settings.jsdir)
    cache_control :public, :must_revalidate
    coffee (settings.jsdir + '/' + params[:splat].first).to_sym
  end

  get '/stylesheets/*.css' do
    content_type 'text/css', :charset => 'utf-8'
    filename = params[:splat].first
    scss filename.to_sym, :views => "#{settings.root}/assets/stylesheets"
  end
end
