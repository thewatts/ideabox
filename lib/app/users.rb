class IdeaBoxApp < Sinatra::Base

  get '/users' do
    users = User.all
    haml :users, locals: { users: users }
  end

  get '/users/:nickname' do |nickname|
    user = User.find_by_nickname(nickname)
    haml :user, locals: { user: user }
  end

end
