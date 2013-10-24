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

  get '/settings' do
    authorize!
    user = current_user
    haml :user_settings, locals: { user: user }
  end

  put '/users/:id' do |id|
    user = User.find(id.to_i)
    user.update_attributes({:phone => params[:user][:phone]})
    redirect back
  end

end
