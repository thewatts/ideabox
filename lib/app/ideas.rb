class IdeaBoxApp < Sinatra::Base

  get '/' do
    if current_user
      redirect '/activity'
    else
      haml :home, :layout => false
    end
  end

  post '/' do
    params[:idea].merge!({"user_id" => current_user.id})
    idea = Idea.create(params[:idea])
    data = {
      :idea => idea.to_h,
      :user => {
        :name => idea.user.name,
        :image => idea.user.image
      }
    }
    Pusher['activity_channel'].trigger('new_idea', :data => data)
    redirect "/"
  end

  get 'ideas/:id/edit' do |id|
    idea = Idea.find(id.to_i)
    haml :edit, locals: { idea: idea }
  end

  put '/:id' do |id|
    #if request.headers["Content-Type"] == "application/json"
    #  # make json
    #else
    Idea.update(id.to_i, params[:idea])
    redirect back
  end

  delete '/:id' do |id|
    Idea.delete(id.to_i)
    redirect '/'
  end

  post '/:id/like' do |id|
    idea = Idea.find(id.to_i)
    idea.like!
    idea.add_fan(current_user.id)
    idea.update_attributes({:fans => idea.fans})
    redirect back
  end

  get '/ideas/:id' do |id|
    authorize!
    idea = Idea.find(id.to_i)
    fans = idea.fans.uniq.map { |id| User.find(id) }
    haml :idea, locals: { idea: idea, fans: fans }
  end

  get '/tags' do
    authorize!
    tags = Idea.tags
    haml :tags, locals: { tags: tags }
  end

  get '/tags/:tag' do |tag|
    authorize!
    ideas = Idea.find_all_by_tag(tag)
    haml :tag, locals: { tag: tag, ideas: ideas }
  end

end
