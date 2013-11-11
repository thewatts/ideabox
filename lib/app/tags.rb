class IdeaBoxApp < Sinatra::Base

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
