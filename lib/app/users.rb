class IdeaBoxApp < Sinatra::Base

  ['/users', '/users/'].each do |route|
    get route do
      redirect '/activity'
    end
  end

  get '/users/:nickname' do |nickname|
    authorize!
    user = User.find_by_nickname(nickname)
    haml :user, locals: { user: user }
  end

end
