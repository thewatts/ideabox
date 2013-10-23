class IdeaBoxApp < Sinatra::Base

  get '/' do
    haml :index, locals: { ideas: Idea.all.sort, idea: Idea.new }
  end

  post '/' do
    params[:idea].merge!({"user_id" => current_user.id})
    idea = Idea.create(params[:idea])
    Pusher['test_channel'].trigger('new_idea', :idea => idea.to_h)
    #redirect "/"
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

end
